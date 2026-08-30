# Writing Style

Body-text style for wiki pages: synthesize, don't translate; the
translation-ese anti-pattern table; code annotation; language
policy; Chinese typography conventions. Load when writing or
editing page body text. Page structure/anatomy lives in
`page-patterns.md`.

## Synthesize, Don't Translate

Do NOT 1:1 translate the source into wiki pages. The source is
raw material — the wiki page is a curated synthesis:

- **Restructure by conceptual relevance**, not source section
  order.
- **No source-framing sentences** — the page-bottom footnote
  definition (`[^1]: [[source-note]]`) already identifies the
  source; it needs no sentence-level announcement. Forbidden
  patterns: "本文基于《X》编写"、"本页根据 X 整理"、"X 译自
  ..."。Never wikilink the source in the body — the source
  wikilink belongs ONLY in the footnote definition block.
- **Key takeaways go at the TOP** — if the source has a
  gotchas/limitations section, those insights belong in the
  opening section as a `> [!NOTE]` callout.
- **Cut and consolidate** — if 5 paragraphs can be replaced by a
  3-line summary + code block, use the latter.
- **Decide what belongs where** — if a section overlaps with
  another concept that has its own page, move detail there and
  replace with a summary + `[[wikilink]]`.
- **Examples: few but essential** — 3–5 representative examples,
  not one per feature variant. Multiple examples must be
  organized by logic, never laid out flat — see「Code Example
  Organization (MANDATORY)」below.
- **Examples must be generic** — only reusable, dependency-light
  patterns belong in the wiki. Domain-coupled examples (specific
  file formats, niche ecosystem libs like glob+image thumbnail
  pipelines) stay out even when the source documents them.

The test: would someone who already knows the topic find this
page useful? If it reads like a translated tutorial, it failed.

When ingesting a book chapter, group related sections under
thematic `##` headings with `###` sub-sections. Don't mirror the
source's flat section list. English heading shorthand like "In
Function Signatures" must become descriptive, not a literal
translation.

## Natural Wikilink Placement

Wikilinks should arise naturally from the prose, not as orphaned
parenthetical afterthoughts:

- ❌ Forbidden: standalone parenthetical link sentences —
  「（相关机制见 [[x]]。）」「（另一框架的类似机制见 [[y]]。）」—
  removing them changes nothing, which means the link was forced
  navigation, not content.
- ✅ Correct: embed the link in a sentence that carries real
  information on its own — a comparison, a scope caveat, a
  practice pointer (e.g. 「StructLogMiddleware 的异常兜底设计见
  [[fastapi-structlog-integration]]」).
- If a candidate page has nothing natural to say, drop the link
  rather than force it; forced links hurt readability and defeat
  the point of making pages visible.
- Cross-page fact delegation: a fact recorded on another page can
  be referenced via wikilink without inventing a local source
  footnote here — the linked page carries its own citation.

## Translation-Ese Anti-Patterns (FORBIDDEN)

Concrete examples of what to avoid and how to fix:

| ❌ Translation-ese | ✅ Natural Chinese |
|:---|:---|
| "Service 坐在这组 Pod 前面" (sits in front of) | "Service 为这组 Pod 提供一个固定入口" — drop spatial metaphors from English |
| "X 是解决 Y 的抽象" | "X 要解决的问题是 Y" — English noun-clause-as-noun, split into topic-comment |
| "但协作不同的工作" | "但各司其职" — don't translate "collaborate on different work" literally |
| "哪些 Pod 我应该保持运行？" | "我应该保持哪些 Pod 运行？" — Chinese wh-questions are NOT subject-aux inverted |
| "暴露出下一个难题" | "带来了下一个问题" — "expose" is not "暴露" in this context |
| "分别回答不同范围的访问需求" | "分别对应不同的访问范围" — things don't "answer" requirements in Chinese |
| "TLS 终结" | "TLS 终止" — "termination" is "终止", not "终结" |
| "ClusterIP 是理解 Service 的最佳起点" | Delete entirely — tutorial scaffolding, not knowledge. Just state what ClusterIP does. |
| "你只需向 Kubernetes 提交描述" | "只需向 Kubernetes 提交描述" — no second-person in knowledge base |

**Self-check**: after writing a section, read it aloud. If it
doesn't sound like something a Chinese engineer would say to a
colleague, rewrite it. Red flags:

- Spatial/directional metaphors from English ("sits in front
  of", "sits above", "behind")
- Abstract nouns built from clauses ("解决X的抽象", "回答Y的机制")
- English-style wh-question word order
- Verbs that are direct dictionary translations of English
  phrasal verbs ("暴露问题" for "expose a problem", "协作工作"
  for "collaborate on work")
- **Second-person "你" in body text** — a knowledge base doesn't
  address the reader. Don't say "你只需提交描述"; say "只需提交描
  述". Don't say "如果你在代码里写死了 IP"; say "如果在代码里写死
  了 IP". WARNING callouts are the only acceptable place for "你"
  (e.g. "永远不要在生产环境直接创建 Pod").
- **Tutorial framing / learning-path guidance** — blog
  scaffolding like "这是理解 X 的最佳起点", "如果你曾好奇...",
  "从这里开始学习" doesn't belong in notes. It's the blog
  author's pedagogical structure, not knowledge. Delete it and
  just state the fact. Another litmus test: if a sentence tells
  the reader HOW to learn (ordering, where to start, what's
  important to understand first), it's tutorial framing — cut it.

## Code Annotation for Cross-Framework Tutorials

When the source uses a framework unfamiliar to the user (e.g.,
JAX for a PyTorch user), annotate code with emoji markers:

| Emoji | Meaning | Use |
|:---|:---|:---|
| 🔑 | Key API / entry point | The most critical framework call — read this line if nothing else |
| ⚠️ | Pitfall / gotcha | Easy mistakes: numerical instability, silent failures, non-intuitive behavior |
| 💡 | Principle / technique | Underlying mechanism or useful trick worth understanding |

**Code block rules**:

1. 1–2 sentence lead-in before each code block explaining what
   it does and what to focus on.
2. Use `# 🔑` / `# ⚠️` / `# 💡` inline comments to annotate
   key lines.
3. Comments must explain **why this line matters + the PyTorch
   equivalent (if any)**.
4. Explain key API parameters — don't assume framework
   familiarity.
5. **Conceptual sections stay code-free** — 定义/核心思想
   sections describe what and why without inlining code; code
   lives in a dedicated 示例/关键设置 section. Bullets point
   there with「具体写法见下方示例」instead of pasting snippets.
   Only identifiers that ARE the concept (e.g. `OcrMode.FULL_PAGE`)
   may appear inline — multi-identifier call chains like
   `DocumentConverter(format_options={...})` belong in the code
   block, not the prose.

Include a cross-framework correspondence table at the end of each
concept page:

```markdown
| JAX/Flax | PyTorch |
|:---|:---|
| `jax.remat(fn)` | `torch.utils.checkpoint.checkpoint(fn)` |
| `jax.grad(loss_fn)` | `loss.backward()` |
```

## Code Example Organization (MANDATORY)

Code examples must be organized by logic — never laid out flat
(平铺) as a series of sibling examples scattered through the
page body.

- **Multiple examples → one `##` section with `###` subsections**
  — the simplest and default structure: `## 示例` containing one
  `###` per example. The parent `##` is non-leaf and may omit
  the coverage indicator; each `###` keeps its own coverage tag,
  lead-in sentence and inline citations.
- **Name `###` headings by the logic they demonstrate**, not by
  ordinal — forbidden: `### 示例 1` / `### Example 1` / `### 用例一`.
  The title states what the example shows (e.g. `### 全局选项与
  共享状态`, `### 创建时指定与覆盖 callback`).
- **Group by theme when examples span multiple topics** — split
  into multiple `##` sections (one per theme) instead of one
  long flat list.

## Language Policy

Always respond to the user and write wiki page content in the
user's language.

Technical terms should be kept in their original form (English or
otherwise).

Wiki page content (body text, headings, callouts) should be in
the user's language. **Filenames and frontmatter keys are in
English (kebab-case)** — the single authoritative rule. The ONLY
exception: book entity pages use the Chinese book title as
filename (`references/book-digest.md`).

## Chinese Writing Conventions

- **Bold only, no italics** — Chinese typography does not use
  italics for emphasis; italics read as foreign/translation-ese.
  Use `**加粗**` for emphasis; never `*斜体*` / `_斜体_` for
  labels, emphasis, or terminology. Nested structural labels
  under a bold parent carry NO markdown decoration — a plain
  `- 子类名：` reads cleaner than double-nested bold.
- **Scannable distributions: bullets, not prose** — enumerable
  data (percentage distributions, rankings, granularity/usage
  breakdowns) must be bullet lists or tables, never
  顿号/comma-separated prose. One bullet per item
  (`- encoder-only：47.8%（44/92）`), with the lead-in sentence
  carrying the `[^N]` footnote before each bullet group. ≥3
  parallel items or any ranked data → bullets; short narrative
  conclusions (2 items + a verdict) may stay as prose. The rule
  applies to the whole page being edited, not just new
  sections — convert pre-existing prose too (flag large edits to
  the user).

## Markdown Detail Rules

- **Math formulas in `$...$`** — `$O(\log n)$`, not
  `` `O(log n)` ``. Code identifiers use backticks.
- **Nested list indentation is 4 spaces** — for both ordered and
  unordered lists.
