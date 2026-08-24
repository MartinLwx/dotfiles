# Core Operations

Generic wiki operations: ingest new sources, re-digest after poor
extraction, answer queries, and take paper reading notes. Load
this file when the task is one of these. For book-clipping
ingests, load `book-digest.md` instead — it is the book-source
specialization of Ingest.

## Ingest

When the user provides a source (URL, file, paste):

0. **Check if source already captured** — search `sources/` with
   broad patterns (`*topic*`, not exact filenames) before
   fetching.
1. **Capture the source** to the appropriate `sources/`
   subdirectory.
   - URL → `defuddle parse <url> --md`.
   - PDF → `defuddle parse <url> --md`
   - Pasted text → save directly.
   - Name descriptively: `sources/blogs/author-topic-year.md`.
2. **Discuss takeaways** with the user.
3. **Present the modification plan before any write** — if the
   ingest would create/update ≥2 pages, list the new pages (name
   + skeleton), the pages to enrich, and any taxonomy changes,
   then wait for confirmation. Single-page updates need only a
   one-line plan.
4. **Check what already exists** in the wiki.
5. **Write or update wiki pages** — one source can trigger
   updates across 5–15 pages.
6. **Run health check** on all created/modified pages (don't wait
   to be asked) — load `health-check.md`.
7. **Update index.md and log.md**.
8. **Report what changed**.

### log.md conventions

- Entries are **newest-first**: insert a new record at the TOP of
  the body, immediately after the frontmatter closing `---`,
  adjacent to other same-day entries — never append at the file
  end. Read the existing entry order before picking the insertion
  point.
- index.md entries are inserted at the end of their section
- Rotate the log: when `./wiki/log.md` exceeds 500 entries, rename
  it to `log-YYYY.md` and start fresh.

## Re-Digest After Poor Extraction

When a source was previously ingested but the PDF-to-Markdown
extraction was poor (noise headers, image refs without
descriptions, missing slide content):

1. Re-read the raw source file in `sources/` — the content may be
   richer than what the initial extraction captured.
2. Compare existing wiki pages against the raw source to identify
   gaps (missing sections, thin content, uncaptured details).
3. Enrich existing pages in-place with missing content — add new
   sections, expand thin ones, add detail to tables.
4. Run health check on all modified pages.
5. Update `index.md` descriptions and `log.md`.

Do NOT create duplicate pages. Enrichment goes into the existing
pages; `source_cnt` stays the same if no new source document is
added.

## Paper Reading Notes

When the user asks to read a paper and create notes, the resulting
wiki page MUST answer the five key questions documented in
[[paper-reading]]:

1. **What problem does this paper try to solve?** — One-paragraph
   summary in your own words, not copied from the abstract.
2. **Why is this an important and hard problem?** — Context and
   challenges that make the problem non-trivial.
3. **Why can't previous work solve this problem?** — Limitations
   of existing approaches and core assumptions they rely on.
4. **What is novel in this paper?** — The one-sentence
   contribution: new architecture, loss, training paradigm, or
   key engineering insight.
5. **Does it show good results?** — Critical assessment: are the
   experiments convincing? Any missing baselines? Could
   confounding factors explain the improvement?

For single-paper notes, structure the page as: problem statement
→ significance → prior work limitations → core innovation →
experimental assessment. Use `[^N]` citations to the paper source
throughout.

For multi-paper comparisons, use the three-paragraph review
format: paper 1 summary, paper 2 summary, cross-paper
connections (compare/apply/synthesize).

When the paper enriches an existing wiki page (e.g., the paper is
a key work in an existing concept page), update that page with a
summary + `[[wikilink]]` to the paper's entity page.

## Query

When the user asks a question about the wiki's domain:

1. Read `./wiki/index.md` and identify the 1–3 most relevant
   pages.
2. Read the relevant pages.
3. Synthesize an answer with proper citations.
4. File substantial answers back to `./wiki/synthesis/`.
5. Update `./wiki/log.md` and `./wiki/index.md` if filed.

Use coverage indicators effectively:

- `[coverage: high]` — trust this section, skip raw sources.
- `[coverage: medium]` — good overview, check raw sources for
  granular questions.
- `[coverage: low]` — read the raw sources directly.

## Cross-Cutting Discipline

- **Ask before mass-updating** — confirm scope if an ingest would
  touch 10+ existing pages.
- **SCHEMA.md and audit.py are optional** — infer conventions
  from existing pages when absent. Never block on a missing
  schema.
- **Unicode smart quotes in source filenames** — macOS/Obsidian
  often produce smart quotes (`'` U+2019). Use shell globbing via
  terminal to handle them.
