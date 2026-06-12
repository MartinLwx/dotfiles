---
name: my-llm-wiki
description: "Provides access to the user's personal wiki, including notes, research, project documentation, decisions, and archived knowledge. Use this skill whenever the user wants to: ingest a new source into the wiki, find answers from the existing wiki, or perform a health check of the wiki."
metadata:
  hermes:
    requires_tools: [web_extract, search_files, read_file]
---

## Wiki Location

*Location*: Set via `WIKI_PATH` environment variable.

If unset, defaults to `/llm-wiki`

The wiki is just a directory of markdown files. No database, no special tooling required. 

## Architecture

```
 .
├──  sources         # Do not modify files in this folder.
    ├──  assets      # Images, diagrams referenced by all wiki pages.
    ├──  books       # The clippings from specific book.
    ├──  blogs       # Web articles, clippings.
    ├──  documents   # The official documents of various tools.
    ├──  papers
    └──  products    # The product information.
└──  wiki  
    ├──  entity      # Minimal units representing a specific, identifiable instance. e.g., person, book, blog.
    ├──  concept     # Minimal units representing an abstract idea or category. e.g., idea, phenomena, framework.
    ├──  SCHEMA.md   # Conventions, structure rules, domain config
    ├──  index.md    # Sectioned content catalog with one-line summaries
    ├──  log.md      # Chronological action log (append-only, rotated yearly)
    └──  synthesis   # Structured composition of entities and concepts that conveys higher-level knowledge.
```

## Resuming an Existing Wiki (CRITICAL — do this every session)

When the user has an existing wiki, *always orient yourself before doing anything*:

1. *Read `./wiki/SCHEMA.md`* — understand the domain, conventions, and tag taxonomy.
   **If SCHEMA.md doesn't exist** (some wikis skip it): note the absence and proceed. Use the existing pages' frontmatter and tag patterns as a de facto schema — infer conventions from what's already there. Never fail the orientation step because of a missing schema.
2. *Read `./wiki/index.md`* — learn what pages exist and their summaries.
3. *Scan recent `./wiki/log.md`* — read the last 20-30 entries to understand recent activity.

Only after orientation should you ingest, query, or lint. This prevents:
- Creating duplicate pages for entities that already exist
- Missing cross-references to existing content
- Contradicting the schema's conventions
- Repeating work already logged

For large wikis (100+ pages), also run a quick `search_files` for the topic
at hand before creating anything new.

## Tag Taxonomy

[Define 10-20 top-level tags for the domain. Add new tags here BEFORE using them.]

Example for AI/ML:
- Models: model, architecture, benchmark, training
- People/Orgs: person, company, lab, open-source
- Techniques: optimization, fine-tuning, inference, alignment, data
- Meta: comparison, timeline, controversy, prediction

Rule: every tag on a page must appear in this taxonomy. If a new tag is needed,
add it here first, then use it. This prevents tag sprawl.

## Entity Pages

One page per notable entity. Include:
- Overview / what it is
- Key facts and dates
- Relationships to other entities ([[wikilinks]])

## Concept Pages

One page per concept or topic. Include:
- Definition / explanation
- Current state of knowledge
- Open questions or debates
- Related concepts ([[wikilinks]])

## Synthesis Pages

Side-by-side analyses. Include:
- What is being compared and why
- Dimensions of comparison (table format preferred)
- Verdict or synthesis
- Sources

### Cookbook-Style Synthesis Pages

When the user requests a cookbook, reference, or quick-lookup page (common for CLI tools, libraries, frameworks):

1. **Code + shell output pairing is mandatory** — every code example showing a struct definition or API usage MUST be immediately followed by the corresponding `--help` output and/or runtime shell output. The code shows the "how to write it", the shell output shows "what the user sees". Without both, the reader cannot establish the connection between source code and CLI behavior.

2. **Error demonstrations are part of the spec** — for validation, parsing, and constraint features, include shell output showing what happens on **invalid** input (the `❌ error: ...` lines). These are as important as the success cases for a reference page.

4. **Behavioral details in callouts** — use `> [!NOTE]` Obsidian-style callouts (NOT bare `>` blockquotes) for non-obvious behaviors: `-h` vs `--help` differences, doc comment truncation rules, default action mappings (`Vec<T>` → `Append`, `bool` → `SetTrue`), attribute interactions (`propagate_version` + subcommands). Each subsequent paragraph line also prefixed with `>`.

4. **Keep it scannable** — every section should be findable by scanning h2/h3 headers. A speed-reference table at the end (需求 → 写法) is highly valued by the user.

5. **Conciseness over tutorial prose** — the source file already contains the full narrative. The cookbook page is for lookup. Cut explanatory paragraphs ruthlessly; let the code and shell output speak.

## Core Operations

### Ingest

When the user provides a source (URL, file, paste), integrate it into the wiki:
0. *Check if source already captured* — Before fetching anything, search `sources/` for existing files matching the topic.  
   The user may have already saved it via defuddle, Obsidian clipper, or manual save.
   ```bash
   search_files(target='files', pattern='<keyword>', path='sources/')
   ```
   If found, use that file as the source — skip the fetch step entirely.
1. *Capture the source*, and save to corresponding subdirectory in `sources/`.
    - URL → prefer `defuddle parse <url> --md` (load the `defuddle` skill first). Fallback: use browser tools — `browser_navigate` to the page, then `browser_console` with `document.querySelector('main')?.innerText || document.querySelector('article')?.innerText` to extract clean text. (docs.rs uses `<main>`, many blogs use `<article>`; try both.)
    - PDF → use `defuddle parse <url> --md` if the PDF is served over HTTP, or `web_extract` if available.
    - Pasted text → save to appropriate subdirectory
    - Name the file descriptively: `sources/blogs/karpathy-llm-wiki-2026.md`
2. *Discuss takeaways with the user*
3. *Check what already exists*
4. *Write or update wiki pages:*
5. *Run health check*
6. *Update the navigations*
7. *Report what changed*

A single source can trigger updates across 5-15 wiki pages. This is normal
and desired — it's the compounding effect.

### Query

When the user asks a question about the wiki's domain:
1. Read `./wiki/index.md` and identify the 1–3 wiki pages most likely to contain the answer.
2. *For wikis with 100+ pages*, also `search_files` across all `.md` files
   for key terms — the index alone may miss relevant content.
3. *Read the relevant pages* using `read_file`.
4. *Synthesize an answer* from the compiled knowledge. Include proper citations so 
   the user can trace where the information came from.
5. *File valuable answers back* — if the answer is a substantial comparison,
   deep dive, or novel synthesis, create a page in `./wiki/synthesis/`
   Don't file trivial lookups — only answers that would be painful to re-derive.
6. Append a new entry to `./wiki/log.md` and `./wiki/index.md` if it was filed.

Use converage indicators *effectively*.
- `[coverage: high]` -- trust this section, skip the raw files.
- `[coverage: medium]` -- good overview, check raw sources for granular questions.
- `[coverage: low]` -- read the raw sources listed in that section directly.

### Lint / Health Check

> [!NOTE]
> Only perform actions after the user confirms. Run health checks proactively on all
> pages created or modified during an ingest session — don't wait to be asked.

Run `references/audit.py` against the pages in question to catch coverage N and source_cnt
mismatches automatically. If audit.py is absent (common), run the portable health check from
`references/health-check-script.md` via `execute_code` — it covers the same rules without external dependencies. Then verify any remaining items below manually.

**Expect failures on first pass.** The fix → re-check cycle is normal: run the check,
fix every issue it finds, re-run until all pages pass. Never ship pages with known health
check failures — a failing check means the coverage indicators and footnote counts are lies.

#### 1. Coverage N = unique source documents (STRICT)

For every section with a `[coverage: ... -- N sources]` tag, N MUST equal the number of
*unique* source documents referenced in that section via footnotes. Common mistakes:

- **Counting footnote references instead of unique sources**: `[^1]`, `[^2]`, `[^3]` all
  pointing to the same `[[doc]]` → N=1, not 3.
- **Guessing N instead of computing it**: always count unique footnote → source mappings.
- **Marking footnote-free sections as N>0**: sections with no `[^N]` at all → `low -- 0 sources`.

#### 2. Coverage level matches N range

| Level | N range |
|-------|---------|
| `high` | N ≥ 5 |
| `medium` | 2 ≤ N ≤ 4 |
| `low` | 0 ≤ N ≤ 1 |

Quick regex check for level/N mismatches:
```sh
# high: N >= 5
rg -nP '\[coverage: high -- [0-4] sources?\]'

# medium: 2 <= N <= 4
rg -nP '\[coverage: medium -- (0|1|[5-9]|\d{2,}) sources?\]'

# low: N <= 1
rg -nP '\[coverage: low -- ([2-9]|\d{2,}) sources?\]'
```
*Action*: Correct each one to match the actual unique source count.

#### 3. source_cnt matches unique footnotes across entire page

`source_cnt` in frontmatter must equal the number of unique `[[Source Name]]` in the
footnote definitions (`[^1]: [[Source]]`) at page bottom. The audit script catches this.

#### 4. Wikilinks are inline, not just footer-only

Whenever body text mentions a concept/entity/synthesis that has its own wiki page, link
it at the point of mention with `[[page]]` or `[[page|display text]]`. Don't relegate
all links to a "相关页面" footer section — this makes the wiki a flat collection, not a graph.

#### 5. Orphan source documents

Find orphan source documents with Obsidian CLI:
```sh
obsidian orphans | rg "^sources/.*"
```
If `obsidian` is absent, tell the user to enable it in Obsidian settings.

*Action*: Delete them with `obsidian delete path=path/to/file` one by one after the user confirms. Do not use `rm`.

## Pitfalls

- *Never modify files in `sources/`* — sources are immutable. Corrections go in wiki pages.
- *Check `sources/` before fetching (broad patterns!)* — when the user mentions a document they've read, always search `sources/` for an existing source file BEFORE fetching from the web. CRITICAL: use **broad** search patterns (e.g. `*clap*`, `*rust*`, `*<topic>*`) not exact filenames like `Rust.md`. The user may have saved it via defuddle or Obsidian with a compound name like `clap_derive_tutorial - Rust.md`. Narrow searches miss these. If nothing found with broad patterns, also try `search_files` across the entire `/llmwiki` root before assuming the source isn't captured. Fetching a duplicate wastes time and makes the user doubt your thoroughness.
- *Always orient first* — read SCHEMA + index + recent log before any operation in a new session.
  Skipping this causes duplicates and missed cross-references.
- *Always update `./wiki/index.md` and `./wiki/log.md`* — skipping this makes the wiki degrade. These are the
  navigational backbone.
- *Index descriptions ≠ page summaries* — `index.md` entries have their own one-line descriptions that are
  authored independently of each page's `summary` frontmatter field. When updating the index to add a new page,
  you must `grep` (or read) the actual index line text to locate existing entries — never assume it matches
  the page's `summary`. The same page may appear differently in the index vs its own frontmatter.
- *Don't create pages without cross-references* — isolated pages are invisible. Every page must
  link to at least 2 other pages.
- *NEVER add `## 相关页面` / `## See also` / `## Related` footer sections* — this is banned.
  Cross-references MUST be inline wikilinks at the point of mention in body text. A standalone
  "相关页面" section at the bottom is exactly the anti-pattern: it turns the wiki graph into a flat
  collection. If a related page isn't naturally mentioned in the body, the body probably doesn't
  need to link to it — or the body should be rewritten to naturally surface the connection.
- *Frontmatter is required* — it enables search, filtering, and staleness detection.
- *Tags must come from the taxonomy* — freeform tags decay into noise. Add new tags to SCHEMA.md
  first, then use them.
- *Keep pages scannable* — a wiki page should be readable in 30 seconds. Split pages over
  200 lines. Move detailed analysis to dedicated deep-dive pages.
- *Ask before mass-updating* — if an ingest would touch 10+ existing pages, confirm
  the scope with the user first.
- *Rotate the log* — when `./wiki/log.md` exceeds 500 entries, rename it `log-YYYY.md` and start fresh.
  The agent should check log size during lint.
- *Handle contradictions explicitly* — don't silently overwrite. Note both claims with dates,
  mark in frontmatter, flag for user review.
- *SCHEMA.md and audit.py are optional* — not every wiki has them. When SCHEMA.md is absent,
  infer conventions from existing pages' frontmatter and tag patterns. When audit.py is absent,
  run the manual health check rules (coverage N, level/N match, source_cnt, inline wikilinks).
  Never block the workflow on missing infrastructure files.
- *Skip wire-format detail unless asked* — when the source contains protobuf definitions, Thrift
  IDL, binary layout specs, or other serialization-level detail, do NOT transcribe it into wiki
  pages. The user wants architectural understanding (how components relate, design rationale,
  trade-offs), not wire-format specifics. Mention that a field has a schema or a message has
  properties, but skip the raw definition blocks. If the user wants that level of detail,
  they'll ask.
- *Math formulas go in $...$* — Big-O notation, logarithms, exponents, and other mathematical
  expressions MUST be wrapped in `$...$` (LaTeX math), not backticks. Examples: `$O(\log n)$`
  not `` `O(log n)` ``, `$O(1)$` not `` `O(1)` ``. Code identifiers and type signatures still
  use backticks: `` `Vec<Node>` ``.
- *Link to dedicated pages, not parent section anchors* — when a sub-concept has its own wiki page
  (e.g., `[[jax-jaxpr]]`, `[[jax-jit]]`), link to THAT page. Do NOT use `[[parent#section]]` anchors
  that point to a section on the parent page. Section anchors are fragile (headings get renamed)
  and they prevent the sub-concept from being a first-class node in the wiki graph. If a dedicated
  page doesn't exist yet but the content warrants one, create it.

## IMPORTANT

Always use the user's language for all responses and for any content written to the wiki or files.

However, the technical terms should be kept.

When ingesting a book chapter, don't mirror the source's flat section list. Group related sections under `##` thematic headings (e.g. "什么是生命周期", "生命周期在函数中的使用", "生命周期在结构体中的使用") with `###` sub-sections underneath. The goal is scannable concept-first grouping, not source-structure preservation. English heading shorthand like "In Function Signatures" must become descriptive Chinese ("生命周期中的函数使用"), not 1:1 literal translation.

### Page Writing: Synthesize, Don't Translate

**CRITICAL**: Do NOT 1:1 translate the source document's structure into wiki pages. The source is raw material — the wiki page is a curated synthesis. This means:

- **Restructure by conceptual relevance**, not by source section order. Ask: "what does the reader need to know first?" not "what did the original document say first?"
- **Key takeaways go at the TOP**. If the source ends with a "Sharp Bits" / "Gotchas" / "Limitations" section, those insights belong in the opening "什么是 X" section (or immediately after it), as a `> [!NOTE]` callout. The reader should know the constraints before diving into details — not discover them as an afterthought at the bottom of the page.
- **Cut and consolidate**. If the source has 5 paragraphs explaining a concept that a 3-line summary + code block can convey, use the latter. Source-proportional page length is a symptom of translation, not synthesis.
- **Decide what belongs where**. When a section of the source overlaps with another concept that has its own page, move the detail to that page and replace the section with a concise summary + `[[wikilink]]`. Don't duplicate.

The test: would someone who already knows the topic find this page useful? If it reads like a translated tutorial, it failed.
