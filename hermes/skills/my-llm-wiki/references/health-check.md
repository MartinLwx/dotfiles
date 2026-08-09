# Health Check

Run on all pages created or modified during an ingest session.
Use `references/audit.py` if present; otherwise use the portable
health check from `references/health-check-script.md` via
`execute_code`.

**Expect failures on first pass.** Fix → re-check until all pages
pass.

## 1. Coverage N = unique source documents (STRICT)

N MUST equal the number of *unique* source documents referenced
via footnotes in that section. Common mistakes:

- **Counting footnote references instead of unique sources**:
  `[^1]`, `[^2]`, `[^3]` all pointing to the same `[[doc]]` →
  N=1, not 3.
- **Guessing N instead of computing it**: always count unique
  footnote → source mappings.
- **Marking footnote-free sections as N>0**: no `[^N]` at all →
  `low -- 0 sources`.

## 2. Coverage level matches N range

| Level | N range |
|-------|---------|
| `high` | N ≥ 5 |
| `medium` | 2 ≤ N ≤ 4 |
| `low` | 0 ≤ N ≤ 1 |

## 3. source_cnt matches unique footnote definitions

`source_cnt` must equal the number of unique `[[Source Name]]`
across all `[^N]: [[Source]]` definitions at page bottom.

## 4. Wikilinks are inline, not footer-only

Link concepts at the point of mention with `[[page]]` or
`[[page|display text]]`. Never use `## 相关页面` / `## 相关概念`
/ `## See also` / `## Related` footer sections.

## 5. Orphan source documents

Find with `obsidian orphans | rg "^sources/.*"`. Delete with
`obsidian delete path=path/to/file` after user confirmation.

## 6. Case-duplicate aliases

Aliases like `"Rust Closures"` and `"rust closures"` on the same
page cause duplicate Quick Search results. Keep only the Title
Case variant.

## Footnote Writing Rules (what the check enforces)

- **Standalone `[^N]` lines are FORBIDDEN** — footnotes MUST be
  inline at the end of a sentence or paragraph, never floating
  alone between elements.
- **Every inline `[^N]` needs a definition; every definition must
  be cited inline** — verify both directions independently after
  writing a page. (a) Inline citations without the page-bottom
  definition block make the health check report `source_cnt: 1`
  while computing `unique sources: 0` — the page is INVALID per
  SCHEMA. (b) Unused footnote definitions are the classic orphan.
  Multi-page ingests are where (a) slips through: the first page
  gets its definition, later pages (e.g. a concept page created
  alongside a cookbook) don't.
- **`[^N]` on heading lines is FORBIDDEN** — the coverage
  indicator (`[coverage: low -- 1 sources]`) belongs on the
  heading line; footnote references (`[^1]`) do NOT. Pattern:
  `## Section [coverage: low -- 1 sources]` followed by
  `Body text.[^1]`. Never:
  `## Section [coverage: low -- 1 sources][^1]`.
- **Tables and lists without footnotes cause predictable
  failures** — when a section's only content is a markdown table
  or bulleted/ordered list derived from the source, add a lead-in
  sentence carrying the footnote: `...：[^1]` followed by the
  table. NEVER put `[^N]` directly on a table row or header —
  Markdown cannot render footnotes inside tables. For lists,
  attach `[^1]` to the lead-in sentence, or to the first item if
  no lead-in exists.
- **Citation scope: `[^N]` only on source-derived or
  reasonably-inferred content** — attach `[^1]` to sentences that
  are (a) direct paraphrases of the source, or (b) reasonable
  summaries/inferences from it. Do NOT attach `[^1]` to
  information added from your own background knowledge that the
  source never mentions (e.g., protocol details, component names,
  governance bodies, version histories, other tools in the
  ecosystem). When in doubt, ask: "did the source say this, or am
  I adding it?" If the latter, no citation. Background knowledge
  in wiki pages is fine — just don't pretend the source provided
  it.
- **Use one footnote number per unique source** — when a single
  source document is the only source for a page, use only `[^1]`
  throughout. Don't create `[^2]` pointing to the same document —
  this confuses the per-section N count (the health check script
  counts unique footnote numbers, not unique source documents
  behind them) and creates unnecessary cleanup work.

## Coverage Recompute Rules

- **Non-leaf `##` sections without coverage tags leak scope** —
  add coverage tags to non-leaf headings to restore section
  boundaries in the health check.
- **Source injection into existing pages** — when a new source
  enriches existing pages, update `source_cnt`, add `[^N]` refs
  and footnote definitions, and update every affected section's
  coverage indicator. When `[^N]` goes into a child `###` section,
  parent `##` sections with coverage tags accumulate ALL child
  footnotes — recompute the parent's N too (e.g. low 1 →
  medium 2), and re-run the health check after all fixes.
- **Book-digest enrichment** (source_cnt 1→2): new inline `[^N]`
  citation + footnote definition at page bottom + frontmatter
  source_cnt + recompute coverage on affected sections (a
  US-market section citing two sources → `medium -- 2 sources`).

## Known Script False Positives

The portable script mis-attributes footnotes in two situations.
In both, the reported N can exceed the true count — always
manually verify before trusting a mismatch.

1. **Last section**: footnote definitions (`[^N]: [[Source]]`)
   at the page bottom are counted as inline citations of the
   final section. If the script's N > your manual count of inline
   `[^N]` in that section's body, it's a false positive — do NOT
   change the coverage tag based on the script. The correct N is
   the count of unique inline citations in the body, not the
   script's automatic count.
2. **Closing paragraph after the last `###` child**: a `##`
   section whose closing paragraph sits AFTER its last `###`
   child gets that paragraph attributed to the child, inflating
   the child's N (e.g. a footnote-free `### 👑` summary table
   reporting N=2 because the parent's 核心结论 paragraph with
   `[^1][^2]` trails it). Fix: move the closing paragraph BEFORE
   the last `###` heading so it sits in the parent's own scope —
   the parent's N is unchanged, and the child returns to its true
   count.

## Tool-Call Cap False Positive

The portable health-check script reads each wikilink via the
read_file TOOL (≤3 calls per link); running it over 10+ pages in
one execute_code can hit the 50-tool-call cap and report false
❌ NOT FOUND for the LAST file checked.

- Before "fixing" a flagged page, re-verify with a tiny targeted
  script (read_file on the exact path) — the failure is usually
  the cap, not the page.
- For big batches, read files with `open(path).read()` inside
  execute_code instead of the read_file tool (no tool-call
  budget).
