/**
 * CWD Jail Extension
 *
 * 任何 tool call 的文件访问都被限制在当前工作目录内（外加白名单目录）。两层防护：
 *
 *  1. System Prompt 层：在 before_agent_start 里向已有 prompt APPEND 一个
 *     自定义 section（不替换整个 prompt），告知 Agent 只能访问当前目录。
 *  2. 拦截层：监听 tool_call 事件，对 read/write/edit/grep/find/ls 校验
 *     path 参数；对 bash/powershell 用启发式分词提取命令中的路径并校验。
 *     非法访问返回 { block: true, reason }，block 结果会回传给模型，
 *     让它自行纠正。
 *
 * 注意：shell 命令检查是启发式的（分词 + 路径解析），无法覆盖所有编码
 * 变体。若需要硬隔离，请配合容器/sandbox 使用（见 pi docs/containerization.md）。
 *
 * 安装：放在项目 .pi/extensions/（仅本项目生效）或 ~/.pi/agent/extensions/
 * （全局生效），Pi 启动时自动加载；开发期可 `pi --extension ./cwd-jail.ts`。
 */

import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

/** path 参数必填的工具 */
const REQUIRED_PATH_TOOLS = new Set(["read", "write", "edit"]);
/** path 参数可选的工具（缺省时默认作用于 cwd，无需拦截） */
const OPTIONAL_PATH_TOOLS = new Set(["grep", "find", "ls"]);
/** shell 类工具，用启发式分词检查 */
const COMMAND_TOOLS = new Set(["bash", "powershell"]);

/**
 * cwd 之外的放行目录白名单，改这个常量即可调整。支持 ~ 前缀（相对 home
 * 展开），相对路径相对 cwd 解析。默认放行 ~/.pi——pi 的配置、skills、
 * 扩展都在这里，属于 agent 应能自我检查的合法范围。
 */
const ALLOWED_ROOTS = ["~/.pi/agent/skills"];

function expandTilde(p: string): string {
	if (p === "~") return os.homedir();
	if (p.startsWith("~/")) return path.join(os.homedir(), p.slice(2));
	return p;
}

/** root（绝对路径）是否包含 abs */
function contains(root: string, abs: string): boolean {
	const rel = path.relative(root, abs);
	return rel === "" || (!rel.startsWith(`..${path.sep}`) && rel !== ".." && !path.isAbsolute(rel));
}

/** 本次会话的全部放行根：cwd + 白名单（已展开为绝对路径）。白名单目录本身
 *  可能是符号链接（如 skills 软链到 dotfiles 仓库），所以把每个根 realpath
 *  解析后的真实位置也加入放行集合，否则 realpath 检查会误拦合法路径。 */
function allowedRoots(cwd: string): string[] {
	const roots = [cwd, ...ALLOWED_ROOTS.map((r) => path.resolve(cwd, expandTilde(r)))];
	const reals = roots.map((r) => {
		try {
			return fs.realpathSync(r);
		} catch {
			return r; // 根目录尚不存在时保留词法路径
		}
	});
	return [...new Set([...roots, ...reals])];
}

function isAllowed(target: string, cwd: string): boolean {
	const abs = path.resolve(cwd, expandTilde(target));
	const roots = allowedRoots(cwd);
	// 词法检查：解析后必须落在 cwd 或某个白名单目录内（~/.pi/../.ssh 这类也会被 resolve 揪出）
	if (!roots.some((root) => contains(root, abs))) return false;
	// 尽力而为的 realpath 检查：捕获符号链接最终指向任何放行根之外的情况
	try {
		const real = fs.realpathSync(abs);
		return roots.some((root) => contains(root, real));
	} catch {
		return true; // 尚不存在的文件（如 write 新建）无 realpath 可解析，词法检查已通过
	}
}

/** 从 shell 命令中启发式提取路径类 token（含子命令替换，一层嵌套） */
function extractCommandPaths(command: string): string[] {
	const tokens = command.match(/"[^"]*"|'[^']*'|\$\([^)]*\)|`[^`]*`|\S+/g) ?? [];
	const paths: string[] = [];
	for (const raw of tokens) {
		if (raw.startsWith("$(") || raw.startsWith("`")) {
			paths.push(...extractCommandPaths(raw.slice(raw.startsWith("$(") ? 2 : 1, -1)));
			continue;
		}
		let tok = raw.replace(/^["']|["']$/g, "");
		// 剥掉环境变量赋值前缀，如 FOO=/etc/passwd
		tok = tok.replace(/^[A-Za-z_][A-Za-z0-9_]*=/, "");
		if (!tok || /^[-+@=<|&;()]/.test(tok)) continue; // 选项、重定向符号等
		const looksLikePath =
			tok.startsWith("/") ||
			tok === "~" ||
			tok.startsWith("~/") ||
			tok.startsWith("..") ||
			tok.startsWith("./") ||
			/^[A-Za-z0-9_.-]+\/.+/.test(tok); // 带斜杠的相对路径
		if (looksLikePath) paths.push(tok);
	}
	return paths;
}

export default function cwdJail(pi: ExtensionAPI) {
	// 第一层：向已有 System Prompt APPEND 一个自定义 section（不替换整个 prompt，
	// Pi 会把它作为 prompt 增量记录进 transcript）
	pi.on("before_agent_start", (event, ctx) => {
		// 白名单与拦截层共用同一常量，prompt 与实际行为保持同步
		const whitelist = ALLOWED_ROOTS.length ? ` and these whitelisted locations: ${ALLOWED_ROOTS.join(", ")}` : "";
		event.systemPromptOptions.sections.workspace_boundary =
			`File access policy: you may ONLY read, write, list, edit, or search ` +
			`files and directories inside the current working directory (${ctx.cwd})${whitelist}. ` +
			`Do not use absolute paths outside it, do not use ".." or "~" to escape ` +
			`it, and do not run shell commands (including subshells, pipes, and ` +
			`redirects) that touch files outside it. If a task seems to require ` +
			`files elsewhere, stop and tell the user instead of attempting access.`;
	});

	// 第二层：拦截非法访问
	pi.on("tool_call", async (event, ctx) => {
		const cwd = ctx.cwd;
		const violations: string[] = [];

		if (REQUIRED_PATH_TOOLS.has(event.toolName)) {
			const p = (event.input as { path: string }).path;
			if (!isAllowed(p, cwd)) violations.push(p);
		} else if (OPTIONAL_PATH_TOOLS.has(event.toolName)) {
			const p = (event.input as { path?: string }).path;
			if (typeof p === "string" && !isAllowed(p, cwd)) violations.push(p);
		} else if (COMMAND_TOOLS.has(event.toolName)) {
			const command = (event.input as { command?: string }).command ?? "";
			for (const p of extractCommandPaths(command)) {
				if (!isAllowed(p, cwd)) violations.push(p);
			}
		}

		if (violations.length === 0) return undefined;

		const reason =
			`Blocked: tool "${event.toolName}" tried to access path(s) ` +
			`${violations.join(", ")} outside the allowed directories: ` +
			`${allowedRoots(cwd).join(", ")}. Retry with paths inside one of ` +
			`these, or ask the user if you need something else.`;

		if (ctx.hasUI) {
			ctx.ui.notify(`cwd-jail: blocked ${event.toolName} (${violations.join(", ")})`, "warning");
		}
		return { block: true, reason };
	});
}
