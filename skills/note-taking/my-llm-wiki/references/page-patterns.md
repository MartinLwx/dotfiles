# Page Patterns

Anatomy of each wiki page type plus the page-level rules that
apply while writing. Load when planning page structure for an
ingest or when writing/editing pages. For body-text style and
Chinese typography, load `writing-style.md`.

## Outline Approval Gate (MANDATORY)

Before creating a new page or rewriting/restructuring an existing
one, present the page outline and **wait for the user's explicit
approval** before writing any content:

- **Frontmatter**: title, exactly 2 tags, aliases, planned
  `source_cnt`, summary.
- **Section skeleton**: every `##`/`###` heading in order, each
  with its planned `[coverage: level -- N]` tag and the
  footnote(s) it will cite; state N as planned unique sources.
- **Source→footnote mapping**: which source gets which `[^N]`
  number, so one-number-per-source holds from the start.
- **Cross-links**: planned `[[wikilinks]]` to ≥2 other pages.

The approved outline is the contract — deviations discovered
while writing (e.g. a section needs an extra source) must be
re-confirmed with the user before proceeding.

## Entity Pages

One page per persistent entity: books, projects, products,
people, platforms.

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

When a design pattern or concept has distinct implementations
across multiple languages, split into:

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

**Self-test**: if you removed the comparison tables, would the
page still coherently explain a single concept? If NO → it's
synthesis, not concept.

**Current State: one paragraph per source, time-first,
chronological (2026-09-10, user rule)** — in a synthesis page's
`## Current State`, unify ALL claims from the SAME source into
ONE prose paragraph (NOT bullets) that opens with that source's
evidence time: 「2026 年 02 月，GLiNER-2 推出了，……」; sort
paragraphs chronologically — earliest first, newest last. No
展望/未来方向 padding. Papers → publication time;
blogs/industry reports → publish time. Ask the user when a date
is uncertain. See `research-page-template.md` for the full rule.

### Tutorial-Digest Synthesis Pages

When a single tutorial covers multiple distinct techniques,
create one synthesis overview + one concept page per technique:

1. **Synthesis page** (`<topic>-techniques`) — comparison table
   of all techniques using SCHEMA emoji conventions (👑/✅/❌/🟡),
   each row a dimension, each column a technique.
2. **Concept pages** — one per technique, with annotated code.
3. Cross-link all pages via inline wikilinks.

### Cookbook-Style Synthesis Pages

For CLI tools, libraries, and frameworks:

1. **Code + shell output pairing is mandatory** — every code
   example must be immediately followed by the corresponding
   `--help` or runtime shell output.
2. **Error demonstrations** — include shell output for invalid
   input (the `❌ error:` lines).
3. **Behavioral details in callouts** for non-obvious behaviors.
4. **Keep it scannable** — every section findable by scanning
   headers.
5. **Conciseness over tutorial prose** — the source file has the
   narrative; the cookbook page is for lookup.

### Research Synthesis Pages

For paper surveys, create `research-<topic>.md` synthesis pages.
Load `references/research-page-template.md` for the full anatomy.
Key rules: 3–5 research lines with distinct core ideas and
representative works; comparison table uses SCHEMA emoji
conventions.

**Explicit timeliness note** — a survey's search window bounds
the validity of every stat it reports. On each affected page:

1. State the coverage window up front (e.g. "检索窗口 2018.1–
   2024.3，58 篇主研究").
2. Label survey statistics as historical baseline, NOT current
   SOTA — especially LLM usage distributions and accuracy numbers.
3. Bridge to newer wiki content: if existing pages cite work that
   postdates the survey, say so — the newer work realizes the
   survey's under-explored directions.

Use a `> [!NOTE]` callout at the top of the survey-derived
section and a dedicated `## 时效性说明` section on single-source
pages.

**Never copy the paper's reference numbers** — survey citations
like "Yang et al. [114]" are dangling noise in the wiki (the
paper's bibliography is usually absent from the markdown
conversion) and collide visually with `[^N]` wiki footnotes.
Strip `[N]` / `[N, M]` tokens entirely; keep author names where
they add identity ("Du et al. 提出三阶段知识级 RAG"). After a
regex strip, remove leftover spaces before Chinese punctuation
(`\s+([，。；：、！？）])`) and between two CJK chars, skipping
table rows to preserve alignment padding.

### Obsidian Kanban / Canvas Base Files

Base files (`.base` extension) in `wiki/base/` are read-only
views aggregating pages by tag. For `.base` file syntax
(filters, properties, views, formulas), load the
`obsidian-bases` skill — this section only records
wiki-specific conventions. Read board results with
`obsidian base:query file=<base>` — never edit the `.base` file
itself.

Create a dedicated grouping tag and add it to every page in the
board. Reference existing boards before creating new ones.

**Creation is two-step** — the `.base` file alone silently shows
empty columns with no warning:

1. Create the `.base` file with `filters`, `properties`, and
   `views`.
2. Populate entity pages — every `property` key declared in the
   `.base` file's `properties` block MUST be added as a
   frontmatter field on every page carrying the base-filter tag.

Example: `courses.base` declares `institution`, `instructor`,
`semester` → each course entity page gets:

```yaml
institution: CMU
instructor: Zhihao Jia
semester: 2025 Fall
```

**Pitfall**: creating only the `.base` file without backfilling
entity page frontmatter. Always verify by checking at least one
tagged page has all declared properties.

**Pitfall: base-filter tags are page-type tags** — a `.base`
board's filter tag must appear ONLY on pages of the matching
type (entity for `Python软件包`/`rust-crate`; concept for
`algorithm`/`python-feature`). Concept pages dissecting a
library's internals (e.g. `altair-chart`, `altair-encoding`)
must carry ONLY the functional tag (`软件包/可视化`) — adding the
entity-type base-filter tag (`Python软件包`) silently pollutes
the board. Before tagging a new page, ask:"would the board that filters on this tag want this page?" — if
not, drop the tag.

## Tag Taxonomy Extensions

### Adding a New Tag

When a new functional category is needed, add it to SCHEMA.md's
taxonomy table first:

```markdown
| 领域 | 子类（已有） |
|------|------------|
| 容器技术 | 运行时, 接口标准, 内核机制, 镜像 |
```

Then use it on the page.

### Promoting a Sub-Category to a New Domain

When a sub-category under an existing domain outgrows its parent
and warrants its own top-level domain:

1. Add the new domain row to SCHEMA.md's taxonomy table.
2. Remove the sub-category from the old domain's row.
3. Migrate all affected pages' functional category tags.
4. Check if any entity pages need new frontmatter fields for the
   new domain's base file.

Example: `机器学习系统/课程` promoted to `课程/MLSys` — course
pages share a common shape (institution, instructor, semester)
that differs from other `机器学习系统` concept pages.

## Algorithm Flow Sections (MANDATORY)

Pages that describe an algorithm or procedure MUST include a
dedicated `## 算法流程` section (placed after 核心思想). The
section contains exactly three labeled parts:

- **输入** — declare every variable in LaTeX math notation, e.g.
  `**输入**: 按 x 升序的 $N$ 个数据点 $p_1, p_2, \ldots, p_N$，
  目标点数 $M$（$2 < M < N$）`. Math variables defined here are
  the single source of truth for the section.
- **输出** — the result in the same notation, e.g.
  `**输出**: 降采样后的 $M$ 个点，恒含首点 $p_1$ 与末点 $p_N$`.
- **算法处理流程** — numbered steps of the procedure. Reference
  the variables defined in 输入 in math form (`$N$`, `$M$`,
  `$B$`) throughout — never prose synonyms like "数据量" or
  "目标点数". Intermediate quantities derived from them (e.g.
  bucket size $B = (N-2)/(M-2)$) are also declared in LaTeX.

If the algorithm is one section of a larger page, the same
输入/输出/算法处理流程 structure applies at that section level.

## Page-Level Rules

- **Frontmatter is required** — enables search, filtering, and
  staleness detection. Write fields with `obsidian property:set`
  (existing keys update in place) or include them in the
  `create` content; `property:set` appends NEW keys at the end —
  order-sensitive fields go in `create` (see `pitfalls.md`).
- **Aliases with special characters must be fully double-quoted**
  — YAML plain scalars cannot start with reserved indicators
  (`@`, backtick), so any alias containing such symbols must be
  wrapped entirely in double quotes: `aliases: [Typer 回调,
  "@app.callback"]`. An unquoted `@app.callback` in a flow
  sequence is invalid YAML and breaks alias parsing in Obsidian.
- **Aliases must be globally unambiguous, scoped by product** —
  an alias is a claim that "searching this term means this page".
  Never alias a qualifier-free generic term ("json 类型",
  "jsonb 类型") on a product-specific page — the same concept
  exists in other systems (MySQL, DuckDB, MongoDB). Scope with
  the product name: "PostgreSQL JSON Types", "PG jsonb". A bare
  generic term is allowed only when it uniquely identifies the
  page across the whole wiki.
- **Frontmatter `summary` ≤ 20 characters** (spaces excluded) —
  one-line description only; anything longer belongs in the page
  body. `index.md` entries stay ≤ 50 chracters per line, whole
  line including `- [[page]] - ` prefix.
- **Tags must come from the taxonomy** — add new tags to
  SCHEMA.md first, then use them.
- **Tag sprawl is a failure mode** — exactly 2 tags per page
  (base-filter + functional category). No broad standalone tags.
- **Multi-concept comparison → synthesis, not concept** — if
  removing comparison tables leaves an incoherent page, it's
  synthesis.
- **Link to dedicated pages, not parent section anchors** —
  `[[jax-jaxpr]]`, not `[[jax#jaxpr]]`.
- **Wikilink in tables: NO alias** — `[[page]]` only;
  `[[page|display]]` breaks table layout. Bare `[[page]]` in
  table cells, `[[page|display]]` OK elsewhere.
- **Wikilinks inside code blocks don't render** — never use
  `[[wikilinks]]` inside any fenced code block, including
  ```text``` architecture chain diagrams like `A → B → C` — the
  temptation is strongest there. Use bare filenames
  (`kubernetes-api-server`) so users can Ctrl-O navigate quickly,
  and link concepts in the surrounding prose. Use ASCII art or
  mermaid for showing structural relationships between pages.
- **Wikilink consistency in taxonomy/tables** — ALL items in the
  same class must get wikilinks uniformly. Ghost links (pages not
  yet created) are valid in Obsidian.
- **Wikilinks must respect conceptual hierarchy** — link Python
  content to `[[python-threading]]`, not `[[rust-threads]]`.
- **Handle contradictions explicitly** — don't silently
  overwrite. Note both claims with dates, flag for user review.
- **Skip wire-format detail unless asked** — don't transcribe
  protobuf, Thrift, or binary layout specs. Architectural
  understanding only.
- **Nested list indentation is 4 spaces** — for both ordered and
  unordered lists.
