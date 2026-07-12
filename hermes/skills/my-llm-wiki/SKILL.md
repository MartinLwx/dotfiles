---
name: my-llm-wiki
description: "Provides access to the user's personal wiki, including notes, research, project documentation, decisions, and archived knowledge. Use this skill whenever the user wants to: ingest a new source into the wiki, find answers from the existing wiki, or perform a health check of the wiki."
metadata:
  hermes:
    requires_tools: [web_extract, search_files, read_file]
---

## Wiki Location

Set via `WIKI_PATH` environment variable. Defaults to `/llmwiki`.

The wiki is a directory of markdown files. No database, no special tooling required.

## Architecture

```
.
├── sources/              # Do not modify. Immutable raw materials.
│   ├── assets/           # Images, diagrams
│   ├── books/            # Book clippings
│   ├── blogs/            # Web articles, clippings
│   ├── documents/        # Official tool documentation
│   ├── papers/           # Academic papers
│   └── products/         # Product information
└── wiki/
    ├── base/             # Obsidian Kanban/Canvas .base files (table views filtered by tag)
    ├── entity/           # Specific, identifiable instances: person, book, project, product
    ├── concept/          # Abstract ideas or categories: idea, phenomenon, framework
    ├── synthesis/        # Comparative analyses of ≥2 entities/concepts
    ├── SCHEMA.md         # Conventions, structure rules, tag taxonomy
    ├── index.md          # Sectioned content catalog with one-line summaries
    └── log.md            # Chronological action log (append-only, rotate yearly at 500+ entries)
```

## Resuming an Existing Wiki (CRITICAL — every session)

Always orient yourself before any operation:

1. **Read `./wiki/SCHEMA.md`** — understand the domain, conventions, and tag taxonomy.
   If SCHEMA.md is absent: note it and infer conventions from existing pages' frontmatter and tag patterns. Never block on a missing schema.
2. **Read `./wiki/index.md`** — learn what pages exist and their summaries.
3. **Scan recent `./wiki/log.md`** — read the last 20–30 entries for recent activity.

Only after orientation should you ingest, query, or lint. This
prevents duplicate pages, missing cross-references, schema
contradictions, and repeated work.

For large wikis (100+ pages), also `search_files` for the topic
at hand before creating anything new.

## Tag Taxonomy

### The Two-Tag Rule

Every page carries **exactly 2 tags**, no more:

1. **Base-filter tag** — powers Obsidian `.base` file `file.hasTag()` filters.
   Examples: `rust-crate`, `rust-trait`, `book`, `python-feature`, `container-runtime`.
2. **Functional category tag** — nested `domain/subcategory` format describing what the page is about.
   Examples: `软件包/日志`, `语言特性/并发`, `容器技术/运行时`, `深度学习/内存优化`.

**Forbidden**:
- Broad standalone tags like `rust`, `python`, `logging`, `security` — too wide, create noise.
- 3+ tags on any page — that's taxonomy, not filtering.

### Adding a New Tag

When a new functional category is needed, add it to SCHEMA.md's taxonomy table first:

```markdown
| 领域 | 子类（已有） |
|------|------------|
| 容器技术 | 运行时, 接口标准, 内核机制, 镜像 |
```

Then use it on the page.

## Entity Pages

One page per persistent entity: books, projects, products, people, platforms.

Include:
- Overview / what it is
- Key facts and dates
- Relationships to other entities ([[wikilinks]])

**Single blog posts / web articles do NOT need entity pages.**
The source file in `sources/blogs/` is the reference; wiki pages
cite it via `[^1]: [[source-filename]]`. Entity pages are for
durable entities only.

## Concept Pages

One page per concept or topic. Include:
- Definition / explanation
- Current knowledge state
- Open questions or debates
- Related concepts ([[wikilinks]])

### Multi-Language Implementations: Hub + Per-Language Pages

When a design pattern or concept has distinct implementations across multiple languages, split into:

1. **Language-agnostic hub** (e.g., `visitor-pattern`) — the
   concept definition, core motivation, pattern structure, and a
   paradigm comparison table (e.g., OOP vs Rust). Links to each
   language-specific page.
2. **Per-language implementation pages** (e.g.,
   `rust-visitor-pattern`, `python-visitor-pattern`) — code
   examples, API details, language-specific caveats.

**When to split**: the user says implementations differ enough
to warrant separate pages, OR the hub would exceed ~200 lines.

**Migration**: when an existing language-specific page should
become language-agnostic, move the code to a new
`<lang>-<concept>` page and rewrite the original as the hub.

**Cross-linking**: hub links to each implementation; each
implementation links back to the hub AND to its source entity.
The hub is the primary wikilink target from other pages.

### Embedded Paradigm-Comparison Tables

When a concept differs fundamentally between paradigms (OOP vs
FP, language A vs language B), include a comparison table
**within the concept page** — this is one concept, not ≥2 being
compared.

Table structure: rows = comparison dimensions, columns = the
paradigms, followed by a root-cause explanation subsection.

This is distinct from synthesis comparison tables (which compare
different concepts).

## Synthesis Pages

Comparative analyses of ≥2 entities/concepts. Create in
`wiki/synthesis/` when the primary mode is relational, not
definitional.

Include:
- What is being compared and why
- Comparison dimensions (table format preferred)
- Verdict or synthesis
- Sources

**Self-test**: if you removed the comparison tables, would the page still coherently explain a single concept? If NO → it's synthesis, not concept.

### Tutorial-Digest Synthesis Pages

When a single tutorial covers multiple distinct techniques, create one synthesis overview + one concept page per technique:

1. **Synthesis page** (`<topic>-techniques`) — comparison table of all techniques using SCHEMA emoji conventions (👑/✅/❌/🟡), each row a dimension, each column a technique.
2. **Concept pages** — one per technique, with annotated code.
3. Cross-link all pages via inline wikilinks.

### Cookbook-Style Synthesis Pages

For CLI tools, libraries, and frameworks:

1. **Code + shell output pairing is mandatory** — every code
   example must be immediately followed by the corresponding
   `--help` or runtime shell output.
2. **Error demonstrations** — include shell output for invalid
   input (the `❌ error:` lines).
3. **Behavioral details in callouts** — use `> [!NOTE]` for
   non-obvious behaviors.
4. **Keep it scannable** — every section findable by scanning
   headers. Include a speed-reference table at the end.
5. **Conciseness over tutorial prose** — the source file has the
   narrative; the cookbook page is for lookup.

### Research Synthesis Pages

For paper surveys, create `research-<topic>.md` synthesis
pages. Load `references/research-page-template.md` for the full
anatomy. Key rules: 3–5 research lines with distinct core ideas
and representative works; comparison table uses SCHEMA emoji
conventions.

### Obsidian Kanban / Canvas Base Files

Base files (`.base` extension) in `wiki/base/` are read-only views aggregating pages by tag.

**Format** — YAML with `filters`, `views`, and optional `properties`:

```yaml
filters:
  and:
    - file.hasTag("<tag>")
properties:
  <frontmatter_key>:
    displayName: 中文列名
views:
  - type: table
    name: <board name>
    order:
      - file.name
      - summary
      - tags
```

Create a dedicated grouping tag and add it to every page in the
board. Reference existing boards before creating new ones.

## Core Operations

### Ingest

When the user provides a source (URL, file, paste):

0. **Check if source already captured** — search `sources/` with broad patterns before fetching.
1. **Capture the source** to the appropriate `sources/` subdirectory.
   - URL → `defuddle parse <url> --md` (load the `defuddle` skill first). Fallback: browser tools.
   - PDF → `defuddle parse <url> --md` or `web_extract`.
   - Pasted text → save directly.
   - Name descriptively: `sources/blogs/author-topic-year.md`.
2. **Discuss takeaways** with the user.
3. **Check what already exists** in the wiki.
4. **Write or update wiki pages** — one source can trigger updates across 5–15 pages.
5. **Run health check** on all created/modified pages (don't wait to be asked).
6. **Update index.md and log.md**.
7. **Report what changed**.

### Query

When the user asks a question about the wiki's domain:
1. Read `./wiki/index.md` and identify the 1–3 most relevant pages.
2. For large wikis, also `search_files` across all `.md` files for key terms.
3. Read the relevant pages.
4. Synthesize an answer with proper citations.
5. File substantial answers back to `./wiki/synthesis/`.
6. Update `./wiki/log.md` and `./wiki/index.md` if filed.

Use coverage indicators effectively:
- `[coverage: high]` — trust this section, skip raw sources.
- `[coverage: medium]` — good overview, check raw sources for granular questions.
- `[coverage: low]` — read the raw sources directly.

### Health Check

Run on all pages created or modified during an ingest session.
Use `references/audit.py` if present; otherwise use the portable
health check from `references/health-check-script.md` via
`execute_code`.

**Expect failures on first pass.** Fix → re-check until all
pages pass.

#### 1. Coverage N = unique source documents (STRICT)

N MUST equal the number of *unique* source documents referenced
via footnotes in that section. Common mistakes:

- **Counting footnote references instead of unique sources**:
  `[^1]`, `[^2]`, `[^3]` all pointing to the same `[[doc]]` →
  N=1, not 3.
- **Guessing N instead of computing it**: always count unique
  footnote → source mappings.
- **Marking footnote-free sections as N>0**: no `[^N]` at all →
  `low -- 0 sources`.

#### 2. Coverage level matches N range

| Level | N range |
|-------|---------|
| `high` | N ≥ 5 |
| `medium` | 2 ≤ N ≤ 4 |
| `low` | 0 ≤ N ≤ 1 |

#### 3. source_cnt matches unique footnote definitions

`source_cnt` must equal the number of unique `[[Source Name]]`
across all `[^N]: [[Source]]` definitions at page bottom.

#### 4. Wikilinks are inline, not footer-only

Link concepts at the point of mention with `[[page]]` or
`[[page|display text]]`. Never use `## 相关页面` / `## 相关概念`
/ `## See also` / `## Related` footer sections.

#### 5. Orphan source documents

Find with `obsidian orphans | rg "^sources/.*"`. Delete with
`obsidian delete path=path/to/file` after user confirmation.

#### 6. Case-duplicate aliases

Aliases like `"Rust Closures"` and `"rust closures"` on the same
page cause duplicate Quick Search results. Keep only the Title
Case variant.

## Pitfalls

- **Never modify files in `sources/`** — sources are
  immutable. Corrections go in wiki pages.
- **Check `sources/` before fetching with broad patterns**
  — use `*topic*`, not exact filenames. Also try
  `search_files` across `/llmwiki` root before concluding
  a source isn't captured.
- **Always orient first** — read SCHEMA + index + recent
  log before any operation.
- **Always update index.md and log.md** — these are the
  navigational backbone. Index descriptions are authored
  independently of page `summary` fields.
- **Every page must link to ≥2 other pages** — isolated
  pages are invisible.
- **Patch into index.md needs extra context** — include
  ≥3 lines before AND after the insertion point in
  `old_string`. Always `read_file` the affected range
  after patching to verify no entries were lost.
- **Entity page chapter-tracking checklist** — when adding
  a chapter to a book entity page, update: (a) table row,
  (b) `source_cnt`, (c) footnote definition, (d) coverage
  indicators if unique sources crossed a level threshold.
- **Source injection into existing pages** — when a new
  source enriches existing pages, update `source_cnt`, add
  `[^N]` refs and footnote definitions, and update every
  affected section's coverage indicator.
- **Standalone `[^N]` lines are FORBIDDEN** — footnotes
  MUST be inline at the end of a sentence or paragraph,
  never floating alone between elements.
- **`[^N]` on heading lines is FORBIDDEN** — the coverage
  indicator (`[coverage: low -- 1 sources]`) belongs on
  the heading line; footnote references (`[^1]`) do NOT.
  Pattern: `## Section [coverage: low -- 1 sources]`
  followed by `Body text.[^1]`. Never:
  `## Section [coverage: low -- 1 sources][^1]`.\n- **Tables and lists without footnotes cause predictable
  health check failures** — when a section's only content
  is a markdown table or bulleted/ordered list derived
  from the source, it's easy to forget inline `[^1]`
  citations. **NEVER put `[^N]` directly on a table row
  or header** — Markdown cannot render footnotes inside
  tables. Instead, add a lead-in sentence before the
  table: `...：[^1]`
  followed by the table. For lists, attach `[^1]` to the
  lead-in sentence, or to the first item if no lead-in
  exists. Tables without a lead-in: add one — a single
  sentence explaining what the table shows, carrying the
  footnote.
- **Citation scope: `[^N]` only on source-derived or
  reasonably-inferred content** — attach `[^1]` to
  sentences that are (a) direct paraphrases of the source,
  or (b) reasonable summaries/inferences from it. Do NOT
  attach `[^1]` to information you added from your own
  background knowledge that the source never mentions
  (e.g., protocol details, component names, governance
  bodies, version histories, other tools in the
  ecosystem). When in doubt, ask: "did the source say
  this, or am I adding it?" If the latter, no citation.
  Background knowledge in wiki pages is fine — just don't
  pretend the source provided it.
- **`replace_all` on substrings of structured lines leaves
  orphan fragments** — when using `patch(replace_all=True)`
  to strip a token like `[^2]` from `[^2]: [[Source]]`,
  only the substring is removed, leaving `: [[Source]]` as
  a dangling orphan. For structured patterns (footnote
  definitions, table rows, YAML keys), remove the entire
  line, not a substring. Always re-read every affected
  file after substring `replace_all` to check for orphans.
  `sed -i` is more reliable for stripping orphan remnants
  than `patch`.
- **Use one footnote number per unique source** — when a
  single source document is the only source for a page,
  use only `[^1]` throughout. Don't create `[^2]` pointing
  to the same document — this confuses the per-section N
  count (the health check script counts unique footnote
  numbers, not unique source documents behind them) and
  creates unnecessary cleanup work.
- **Frontmatter is required** — enables search,
  filtering, and staleness detection.
- **Tags must come from the taxonomy** — add new tags to
  SCHEMA.md first, then use them.
- **Tag sprawl is a failure mode** — exactly 2 tags per
  page (base-filter + functional category). No broad
  standalone tags.
- **Aliases must not have case-duplicates** — keep only
  the Title Case variant.
- **Keep pages scannable** — readable in 30 seconds.
  Split pages over ~200 lines.
- **Ask before mass-updating** — confirm scope if an
  ingest would touch 10+ existing pages.
- **Rotate the log** — when `./wiki/log.md` exceeds 500
  entries, rename to `log-YYYY.md` and start fresh.
- **Handle contradictions explicitly** — don't silently
  overwrite. Note both claims with dates, flag for user
  review.
- **SCHEMA.md and audit.py are optional** — infer
  conventions from existing pages when absent.
- **Skip wire-format detail unless asked** — don't
  transcribe protobuf, Thrift, or binary layout specs.
  Architectural understanding only.
- **Math formulas in `$...$`** — `$O(\\log n)$`, not
  `` `O(log n)` ``. Code identifiers use backticks.
- **Link to dedicated pages, not parent section anchors**
  — `[[jax-jaxpr]]`, not `[[jax#jaxpr]]`.
- **Unicode smart quotes in source filenames** —
  macOS/Obsidian often produce smart quotes (`'` U+2019).
  Use shell globbing via terminal to handle them.
- **Wikilink consistency in taxonomy/tables** — ALL items
  in the same class must get wikilinks uniformly. Ghost
  links (pages not yet created) are valid in Obsidian.
- **Health check false-positive on last section** — the
  script counts footnote definitions at page bottom as
  part of the last section's scope. Manually verify before
  trusting a mismatch on the final section.
- **Non-leaf `##` sections without coverage tags leak
  scope** — add coverage tags to non-leaf headings to
  restore section boundaries in the health check.
- **Book entity page pattern** — use
  `references/book-entity-template.md` for book entity
  pages.
- **New domain needs companion entities** — when ingesting
  into an empty domain, create 1 concept + 2 entity stubs
  for the minimum 2-wikilink requirement.
- **Wikilinks must respect conceptual hierarchy** — link
  Python content to `[[python-threading]]`, not
  `[[rust-threads]]`.
- **Nested list indentation is 4 spaces** — for both
  ordered and unordered lists.
- **Multi-concept comparison → synthesis, not concept** —
  if removing comparison tables leaves an incoherent page,
  it's synthesis.
- **Wikilink in tables: NO alias** — `[[page]]` only;
  `[[page|display]]` breaks table layout. Bare `[[page]]`
  in table cells, `[[page|display]]` OK elsewhere.
- **Wikilinks inside code blocks don't render** — never
  use `[[wikilinks]]` inside ``` ``` blocks in Obsidian.
  Use bare filenames (`kubernetes-api-server`) so users
  can Ctrl-O navigate quickly. Use ASCII art or mermaid
  for showing structural relationships between pages.
- **Patch tool: `old_string` must match FILE content, not
  `read_file` display format** — strip the `LINENUM|`
  prefix before constructing `old_string`.
- **Adding table rows: never use the adjacent row as
  `old_string` boundary** — include both old and new row
  in `new_string`, and use only the insertion point as
  `old_string`. Always re-read to verify.

## Page Writing: Synthesize, Don't Translate

Do NOT 1:1 translate the source into wiki pages. The source is
raw material — the wiki page is a curated synthesis:

- **Restructure by conceptual relevance**, not source section
  order.
- **Key takeaways go at the TOP** — if the source has a
  gotchas/limitations section, those insights belong in the
  opening section as a `> [!NOTE]` callout.
- **Cut and consolidate** — if 5 paragraphs can be replaced by a
  3-line summary + code block, use the latter.
- **Decide what belongs where** — if a section overlaps with
  another concept that has its own page, move detail there and
  replace with a summary + `[[wikilink]]`.
- **Examples: few but essential** — 3–5 representative examples,
  not one per feature variant.

The test: would someone who already knows the topic find this
page useful? If it reads like a translated tutorial, it failed.

### Translation-Ese Anti-Patterns (FORBIDDEN)

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
| \"ClusterIP 是理解 Service 的最佳起点\" | Delete entirely — tutorial scaffolding, not knowledge. Just state what ClusterIP does. |
| \"你只需向 Kubernetes 提交描述\" | \"只需向 Kubernetes 提交描述\" — no second-person in knowledge base |

**Self-check**: after writing a section, read it aloud. If it
doesn't sound like something a Chinese engineer would say to a
colleague, rewrite it. Here's a litmus test — these are all red
flags:
- Spatial/directional metaphors from English ("sits in front
  of", "sits above", "behind")
- Abstract nouns built from clauses ("解决X的抽象", "回答Y的机制")
- English-style wh-question word order
- Verbs that are direct dictionary translations of English
  phrasal verbs ("暴露问题" for "expose a problem", "协作工作"
  for "collaborate on work")
- **Second-person "你" in body text** — a knowledge base
  doesn't address the reader. Don't say "你只需提交描述"; say
  "只需提交描述". Don't say "如果你在代码里写死了 IP"; say
  "如果在代码里写死了 IP". WARNING callouts are the only
  acceptable place for "你" (e.g.
  "永远不要在生产环境直接创建 Pod").
- **Tutorial framing / learning-path guidance** — blog
  scaffolding like "这是理解 X 的最佳起点", "如果你曾好奇...",
  "从这里开始学习" doesn't belong in notes. It's the blog
  author's pedagogical structure, not knowledge. Delete it and
  just state the fact. Another litmus test: if a sentence tells
  the reader HOW to learn (ordering, where to start, what's
  important to understand first), it's tutorial framing — cut
  it.

When ingesting a book chapter, group related sections under
thematic `##` headings with `###` sub-sections. Don't mirror the
source's flat section list. English heading shorthand like "In
Function Signatures" must become descriptive, not a literal
translation.

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

Include a cross-framework correspondence table at the end of each concept page:

```markdown
| JAX/Flax | PyTorch |
|:---|:---|
| `jax.remat(fn)` | `torch.utils.checkpoint.checkpoint(fn)` |
| `jax.grad(loss_fn)` | `loss.backward()` |
```

## Language Policy

Always respond to the user and write wiki page content in the user's language.

Technical terms should be kept in their original form (English or otherwise).

Wiki page content (body text, headings, callouts) should be in
the user's language. Filenames and frontmatter keys are in
English (kebab-case).
