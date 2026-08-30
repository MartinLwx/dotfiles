import re
import sys
from pathlib import Path


def normalize_source(name: str) -> str:
    """[[doc#section]] and [[doc]] are the same source: strip anchors."""
    return name.split("#")[0].strip()


def _paragraph_blocks(lines: list[str], start: int, end: int) -> list[tuple[int, int]]:
    """Blank-line-separated blocks within lines[start:end]; [(s, e), ...]."""
    blocks: list[tuple[int, int]] = []
    cur_start: int | None = None
    for i in range(start, end):
        if lines[i].strip() == "":
            if cur_start is not None:
                blocks.append((cur_start, i))
                cur_start = None
        elif cur_start is None:
            cur_start = i
    if cur_start is not None:
        blocks.append((cur_start, end))
    return blocks


def _has_inline_ref(lines: list[str], start: int, end: int, def_lines: set[int]) -> bool:
    for i in range(start, end):
        if i in def_lines:
            continue
        if re.search(r"\[\^\d+\]", lines[i]):
            return True
    return False


def audit_page(filepath: str) -> list[str]:
    """Audit a single wiki page. Returns issue strings (empty = clean)."""
    raw = Path(filepath).read_text()
    lines = raw.split("\n")

    issues: list[str] = []

    # --- Footnote definitions: [^1]: [[Source]] ------------------------
    footnote_defs: dict[str, str] = {}  # number -> normalized source
    def_lines: set[int] = set()
    for i, line in enumerate(lines):
        m = re.match(r"\[\^(\d+)\]:\s*\[\[(.+?)\]\]", line)
        if m:
            footnote_defs[m.group(1)] = normalize_source(m.group(2))
            def_lines.add(i)

    # --- Check 1: source_cnt + one-number-per-source -------------------
    actual_sc = len(set(footnote_defs.values()))
    sc_match = re.search(r"source_cnt:\s*(\d+)", raw)
    declared_sc = int(sc_match.group(1)) if sc_match else 0
    if declared_sc != actual_sc:
        issues.append(
            f"source_cnt: declared={declared_sc} actual_unique_sources={actual_sc}"
        )
    by_source: dict[str, list[str]] = {}
    for num, src in footnote_defs.items():
        by_source.setdefault(src, []).append(num)
    for src, nums in by_source.items():
        if len(nums) > 1:
            issues.append(
                f"source [[{src}]] uses multiple footnote numbers {nums} — one number per source"
            )

    # --- Inline references ---------------------------------------------
    inline_refs: list[tuple[int, str]] = []
    for i, line in enumerate(lines):
        if i in def_lines:
            continue
        for m in re.finditer(r"\[\^(\d+)\]", line):
            inline_refs.append((i, m.group(1)))

    # --- Check 2a: every inline [^N] has a definition ------------------
    for _, num in inline_refs:
        if num not in footnote_defs:
            issues.append(f"inline [^{num}] has no page-bottom definition")

    # --- Check 2b: every definition is cited inline --------------------
    cited = {num for _, num in inline_refs}
    for num in footnote_defs:
        if num not in cited:
            issues.append(f"footnote definition [^{num}] is never cited inline")

    # --- Check 4: no standalone [^N] lines -----------------------------
    for i, line in enumerate(lines):
        if i in def_lines:
            continue
        if re.fullmatch(r"(?:\[\^\d+\]\s*)+", line.strip()):
            issues.append(
                f"line {i+1}: standalone footnote reference (must be inline at sentence end)"
            )

    # --- Check 5: no [^N] on heading lines -----------------------------
    for i, line in enumerate(lines):
        if re.match(r"^#{1,6}\s", line) and re.search(r"\[\^\d+\]", line):
            issues.append(
                f"line {i+1}: footnote reference on heading line (coverage tag only)"
            )

    # --- Section scoping + Check 6/7: coverage N and level -------------
    headings: list[tuple[int, int, str]] = []
    for i, line in enumerate(lines):
        m = re.match(r"^(#{2,3})\s+(.*)", line)
        if m:
            headings.append((i, len(m.group(1)), m.group(2)))

    if headings:
        def section_boundary(k: int) -> int:
            """Next heading with level <= this heading's level, else EOF."""
            level = headings[k][1]
            for j in range(k + 1, len(headings)):
                if headings[j][1] <= level:
                    return headings[j][0]
            return len(lines)

        next_idx = [section_boundary(k) for k in range(len(headings))]

        # Trailing-paragraph rule: when >=2 blank-line-separated blocks
        # follow the last ### child of a ## and the FINAL block carries
        # inline refs, that block belongs to the parent (not the last
        # child) — fixes the historical "parent closing paragraph
        # inflates the last child's N" false positive.
        last_child_end: dict[int, int] = {}
        for k, (start, level, _) in enumerate(headings):
            if level != 2:
                continue
            child_starts = [
                h[0] for h in headings if h[1] == 3 and start < h[0] < next_idx[k]
            ]
            if not child_starts:
                continue
            last_child = child_starts[-1]
            defs_start = min(def_lines) if def_lines else len(lines)
            region_start, region_end = last_child + 1, min(next_idx[k], defs_start)
            if region_start < region_end:
                blocks = _paragraph_blocks(lines, region_start, region_end)
                if (
                    len(blocks) >= 2
                    and _has_inline_ref(lines, blocks[-1][0], blocks[-1][1], def_lines)
                ):
                    last_child_end[last_child] = blocks[-1][0]

        def section_refs(ranges: list[tuple[int, int]]) -> set[str]:
            refs: set[str] = set()
            for li, num in inline_refs:
                if num not in footnote_defs:
                    continue
                for a, b in ranges:
                    if a <= li < b:
                        refs.add(footnote_defs[num])
                        break
            return refs

        for k, (start, level, heading_text) in enumerate(headings):
            if level == 3 and start in last_child_end:
                ranges = [(start, last_child_end[start])]
            else:
                ranges = [(start, next_idx[k])]
            actual_n = len(section_refs(ranges))

            cov_match = re.search(
                r"\[coverage:\s*(high|medium|low)\s*--\s*(\d+)\s*sources?\]",
                heading_text,
            )
            if not cov_match:
                continue
            cov_level, cov_n = cov_match.group(1), int(cov_match.group(2))
            title = heading_text.split("[coverage:")[0].strip()
            if cov_n != actual_n:
                issues.append(f"  {title}: declared N={cov_n} actual_unique={actual_n}")
            expected = (
                "high" if actual_n >= 5 else "medium" if actual_n >= 2 else "low"
            )
            if cov_level != expected:
                issues.append(
                    f"  {title}: level={cov_level} should_be={expected} (N={actual_n})"
                )

    # --- Check 8: nested list indentation (4 spaces per level) ---------
    # YAML block-style lists in frontmatter (tags/aliases) legitimately use
    # 2-space indents — skip the frontmatter region entirely.
    fm_end = 0
    if lines and lines[0].strip() == "---":
        for j in range(1, len(lines)):
            if lines[j].strip() == "---":
                fm_end = j + 1
                break

    in_code = False
    for i, line in enumerate(lines):
        if i < fm_end:
            continue
        if line.lstrip().startswith("```"):
            in_code = not in_code
            continue
        if in_code:
            continue
        m = re.match(r"^(\s*)(?:[-*+]|\d+[.)])\s+", line)
        if not m:
            continue
        indent = len(m.group(1))
        if indent > 0 and indent % 4 != 0:
            issues.append(
                f"line {i+1}: nested list item indented {indent} spaces "
                "(must be a multiple of 4 — 4 spaces per nesting level)"
            )

    name = Path(filepath).name
    if issues:
        return [f"✗ {name}"] + issues
    return [f"✓ {name}"]


def main():
    if len(sys.argv) < 2:
        print("Usage: python audit.py <page1.md> [page2.md ...]")
        sys.exit(1)
    all_clean = True
    for fp in sys.argv[1:]:
        for r in audit_page(fp):
            print(r)
            if r.startswith("✗"):
                all_clean = False
    if all_clean:
        print("\nAll pages clean ✓")
    else:
        print("\nIssues found — fix before updating INDEX/LOG")


if __name__ == "__main__":
    main()
