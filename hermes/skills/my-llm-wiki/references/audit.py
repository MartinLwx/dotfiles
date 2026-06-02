"""
LLM Wiki Health Audit — validate coverage N, source_cnt, wikilinks.

Usage (from hermes_tools context):
    from hermes_tools import read_file
    audit_wiki_pages(["wiki/entity/example.md", ...])

Or standalone:
    python audit.py wiki/entity/page1.md wiki/concept/page2.md
"""

import re
import sys
from pathlib import Path


def parse_stripped(content: str) -> list[str]:
    """Strip read_file line-number prefixes if present."""
    lines = []
    for line in content.split("\n"):
        m = re.match(r"\d+\|(.*)", line)
        lines.append(m.group(1) if m else line)
    return lines


def audit_page(filepath: str) -> list[str]:
    """Audit a single wiki page. Returns list of issue strings (empty = clean)."""
    raw = Path(filepath).read_text()
    lines = raw.split("\n")

    # Build footnote definition map: [^1]: [[Source Name]]
    footnote_defs: dict[str, str] = {}
    for line in lines:
        m = re.match(r"\[(\^\d+)\]:\s*\[\[(.+?)\]\]", line)
        if m:
            footnote_defs[m.group(1)] = m.group(2)

    actual_sc = len(set(footnote_defs.values()))
    sc_match = re.search(r"source_cnt:\s*(\d+)", raw)
    declared_sc = int(sc_match.group(1)) if sc_match else 0

    issues: list[str] = []

    # 1. source_cnt accuracy
    if declared_sc != actual_sc:
        issues.append(
            f"source_cnt: declared={declared_sc} actual_unique_sources={actual_sc}"
        )

    # 2. Per-section coverage N
    headings = [i for i, l in enumerate(lines) if re.match(r"^###\s", l)]
    for idx, start in enumerate(headings):
        end = headings[idx + 1] if idx + 1 < len(headings) else len(lines)
        section_lines = lines[start:end]
        heading_line = section_lines[0]

        cov_match = re.search(
            r"\[coverage:\s*(high|medium|low)\s*--\s*(\d+)\s*sources?\]",
            heading_line,
        )
        if not cov_match:
            continue

        cov_level = cov_match.group(1)
        cov_n = int(cov_match.group(2))

        # Count unique sources cited in this section's footnotes
        fn_refs: set[str] = set()
        for sl in section_lines:
            for m2 in re.finditer(r"\[(\^\d+)\]", sl):
                if m2.group(1) in footnote_defs:
                    fn_refs.add(footnote_defs[m2.group(1)])

        actual_n = len(fn_refs)

        if cov_n != actual_n:
            heading_text = heading_line.split("[coverage:")[0].strip(" #")
            issues.append(
                f"  {heading_text}: declared N={cov_n} actual_unique={actual_n}"
            )

        # 2b. Coverage level matches N range
        expected_level = (
            "high" if actual_n >= 5 else "medium" if actual_n >= 2 else "low"
        )
        if cov_level != expected_level:
            heading_text = heading_line.split("[coverage:")[0].strip(" #")
            issues.append(
                f"  {heading_text}: level={cov_level} should_be={expected_level} (N={actual_n})"
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
        results = audit_page(fp)
        for r in results:
            print(r)
            if r.startswith("✗"):
                all_clean = False

    if all_clean:
        print("\nAll pages clean ✓")
    else:
        print("\nIssues found — fix before updating INDEX/LOG")


if __name__ == "__main__":
    main()
