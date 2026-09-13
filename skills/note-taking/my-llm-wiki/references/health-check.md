# Health Check

Run on all pages created or modified during an ingest session.
Use `references/audit.py` if present

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

## CLI Link-Graph Checks (after any write)

The text-level checks above are complemented by Obsidian's own
link index — run the relevant ones after writes:

- `obsidian unresolved` — every `[[wikilink]]` must resolve
  (catches typos that text grep misses).
- `obsidian orphans` — 0 inbound links violates the ≥2-link rule
  (see §5 for the `sources/` orphan variant).
- `obsidian deadends` — 0 outbound links; the cheap first pass
  for the ≥2-outgoing-links rule (1-link pages still need a
  manual check).
- `obsidian backlinks counts file=<page>` — confirm a new
  cross-link actually landed on the other side.
- `obsidian property:read name=source_cnt path=<page>` — verify
  frontmatter writes landed correctly.

audit.py stays authoritative for coverage / source_cnt / footnote
rules — those are text-level; the CLI cannot check them.

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

## 7. Nested List Indentation (Check 8 in audit.py)

- **Rule**: nested list items (ordered and unordered) must be
  indented **4 spaces per nesting level** — indent must be a
  multiple of 4 (0, 4, 8, ...).
- The check skips YAML frontmatter (block-style `tags:`/`aliases:`
  lists legitimately use 2-space indents), fenced code blocks, and
  blockquotes.
- Common failures: 2-space or 3-space nested bullets; ordered
  sub-lists (`1.`/`2.`) indented like bullets.
- Fix by re-indenting to the next multiple of 4 — the target level
  is the nearest preceding parent item's indent + 4 (sometimes the
  correct fix is 0, e.g. a mis-indented sibling).

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

## Script Accuracy Notes

The rewritten `references/audit.py` handles the two historical
false positives in its scoping logic:

1. **Last section**: footnote definitions (`[^N]: [[Source]]`) at
   the page bottom are never counted as inline citations of the
   final section.
2. **Closing paragraph after the last `###` child**: when ≥2
   blank-line-separated blocks follow the last `###` of a `##`
   section and the final block carries inline refs, the final
   block belongs to the parent `##`, not the child. No manual
   paragraph moving is needed.

If the script still reports an N that contradicts your manual
count, trust the manual count and re-verify before changing any
coverage tag.
