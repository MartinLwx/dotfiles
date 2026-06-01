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

## Core Operations

### Ingest

When the user provides a source (URL, file, paste), integrate it into the wiki:
1. *Capture the source*, and save to corresponding subdirectory in `sources/`.
    - URL → prefer `defuddle parse <url> --md` (load the `defuddle` skill first). Fallback: use browser tools — `browser_navigate` to the page, then `browser_console` with `document.querySelector('article').innerText` to extract clean text.
    - PDF → use `defuddle parse <url> --md` if the PDF is served over HTTP, or `web_extract` if available.
    - Pasted text → save to appropriate subdirectory
    - Name the file descriptively: `sources/blogs/karpathy-llm-wiki-2026.md`
2. *Discuss takeaways with the user* — what's interesting, what matters for
   the domain.
3. *Check what already exists* — search `./wiki/index.md` and use `search_files` to find
   existing pages for mentioned entities/concepts. This is the difference between
   a growing wiki and a pile of duplicates.
4. *Write or update wiki pages:*
    - *New entities/concepts:* Create pages only if they are meaningful that 
      are suitable as standalone wiki pages.
    - *Existing pages:* Add new information, update facts, bump `modified_at` date.
      When new info contradicts existing content, ask users what to do.
    - *Cross-reference:* Every new or updated page must link to at least 2 other
      pages via `[[wikilinks]]`. Check that existing pages link back. If fewer than 
      two relevant pages exist, create links when additional content is available.
5. *Update the navigations*
    - Add new pages to `./wiki/index.md` under the correct section, alphabetically.
    - Append a new record to the `./wiki/log.md` to document the changes.
    - List every file created or updated in the log entry
6. *Report what changed* — list every file created or updated to the user.

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

### Lint

> [!NOTE]
> Only perform actions after the user confirms

When the user asks to lint, health-check, or audit the wiki:

1. *Incorrect coverage level mapping* - You can use the following three ripgrep commands to find the violations (if the `rg` is absent, fallback to `grep`):
```sh
# high: N >= 5
$ rg -nP '\[coverage: high -- [0-4] sources?\]'

# medium: 2 <= N <= 4
$ rg -nP '\[coverage: medium -- (0|1|[5-9]|\d{2,}) sources?\]'

# low: N <= 1
$ rg -nP '\[coverage: low -- ([2-9]|\d{2,}) sources?\]' 
```
*Action*: Correct each one by the coverage indicator rules.

2. *Orphan source* - Find orphan source document with Obsidian CLI. The detail command is
```sh
$ obsidian orphans | rg "^sources/.*"
```
If the `obsidian` is absent, tell the user that he/she should enable it in the Obsidian settings.

*Action*: Delete them with `obsidian delete path=path/to/file` command one by one after the user confirms your plan. Do not use `rm` command

## Pitfalls

- *Never modify files in `sources/`* — sources are immutable. Corrections go in wiki pages.
- *Always orient first* — read SCHEMA + index + recent log before any operation in a new session.
  Skipping this causes duplicates and missed cross-references.
- *Always update `./wiki/index.md` and `./wiki/log.md`* — skipping this makes the wiki degrade. These are the
  navigational backbone.
- *Don't create pages without cross-references* — isolated pages are invisible. Every page must
  link to at least 2 other pages.
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

## IMPORTANT

Always use the user's language for all responses and for any content written to the wiki or files.

However, the technical terms should be kept.
