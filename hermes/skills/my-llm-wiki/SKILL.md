---
name: my-llm-wiki
description: "Provides access to the user's personal wiki, including notes, research, project documentation, decisions, and archived knowledge. Use this skill whenever the user wants to: ingest a new source into the wiki, find answers from the existing wiki, perform a health check of the wiki, or apply recurring workflow patterns (book digest planning, base file population, re-digest, taxonomy promotion, survey digests)."
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
6. **Exactly 2 code examples** (user preference) — one 配置思路
   block exercising ALL ways to set values (single value / array
   per column / function `(x, y) => value` form), with inline
   comments showing cell / row / column targeting; one 配置项一览
   block touching every parameter, followed by speed-reference
   tables (参数 / 含义 / 取值形式).
7. **Lead with the unified-syntax insight** — when the API shares
   one parameter form across options (e.g. grid's
   `align`/`inset`/`fill`/`stroke` all accept
   single-value / array / function forms), state that as the core
   takeaway before any example; the difference is only WHICH
   property you set.
8. **Render-verify honestly** — if the toolchain isn't available
   to verify examples locally, keep them verbatim-close to
   official doc examples and say so in the report; never invent
   output you couldn't produce.

For config-heavy libraries (e.g. structlog), the page anatomy is:
心智模型 section with ASCII architecture diagram + concept table,
`configure()` parameter table (参数/类型/默认值/说明), API
reference tables grouped by function with 输入→输出 column, a
dedicated parameter table for the renderer, recipe sections with
code + output, best practices, and 相关文档 wikilinks to sources.

### Research Synthesis Pages

For paper surveys, create `research-<topic>.md` synthesis
pages. Load `references/research-page-template.md` for the full
anatomy. Key rules: 3–5 research lines with distinct core ideas
and representative works; comparison table uses SCHEMA emoji
conventions.

**Explicit timeliness note** — a survey's search window bounds the
validity of every stat it reports. On each affected page:

1. State the coverage window up front (e.g. "检索窗口 2018.1–
   2024.3，58 篇主研究").
2. Label survey statistics as historical baseline, NOT current
   SOTA — especially LLM usage distributions and accuracy numbers.
3. Bridge to newer wiki content: if existing pages cite work that
   postdates the survey, say so — the newer work realizes the
   survey's under-explored directions.

Use a `> [!NOTE]` callout at the top of the survey-derived section
and a dedicated `## 时效性说明` section on single-source pages.

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

### Re-Digest After Poor Extraction

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

### Paper Reading Notes

When the user asks to read a paper and create notes, the resulting
wiki page MUST answer the five key questions documented in
[[paper-reading]]:

1. **What problem does this paper try to solve?** — One-paragraph
   summary in your own words, not copied from the abstract.
2. **Why is this an important and hard problem?** — Context and
   challenges that make the problem non-trivial.
3. **Why can't previous work solve this problem?** — Limitations of
   existing approaches and core assumptions they rely on.
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

When the paper enriches an existing wiki page (e.g., the paper
is a key work in an existing concept page), update that page
with a summary + `[[wikilink]]` to the paper's entity page.

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

#### Known script false positives

The portable script mis-attributes footnotes in two situations.
In both, the reported N can exceed the true count — always
manually verify before trusting a mismatch.

1. **Last section**: footnote definitions (`[^N]: [[Source]]`)
   at the page bottom are counted as inline citations of the
   final section. If the script's N > your manual count of
   inline `[^N]` in that section's body, it's a false positive —
   do NOT change the coverage tag based on the script. The
   correct N is the count of unique inline citations in the
   body, not the script's automatic count.
2. **Closing paragraph after the last `###` child**: a `##`
   section whose closing paragraph sits AFTER its last `###`
   child gets that paragraph attributed to the child, inflating
   the child's N (e.g. a footnote-free `### 👑` summary table
   reporting N=2 because the parent's 核心结论 paragraph with
   `[^1][^2]` trails it). Fix: move the closing paragraph BEFORE
   the last `###` heading so it sits in the parent's own scope —
   the parent's N is unchanged, and the child returns to its
   true count.

### Splitting an Oversized Page

When a page exceeds ~200 lines, split it into a hub + sub-pages.
Proven workflow (used for research-vulnerability-detection,
364 lines → hub + 6 sub-pages):

1. **Hub keeps the original filename and path** — every inbound
   `[[page]]` link keeps resolving. Obsidian allows a folder and
   a same-named file to coexist; create sub-pages in
   `page-name/` and link them as `[[page-name/subpage]]`.
2. **Grep for anchor links first** (`[[page#heading]]` across
   the wiki) — sections targeted by anchors must stay in the
   hub or the links break. If an anchored section must move,
   rewrite the link as `[[page-name/subpage#heading]]`.
3. **Organize by content nature, not source order**: single-
   topic depth → its own sub-page; cross-cutting comparison
   content (e.g. a "challenges and how each line addresses
   them" section) stays in the hub — it IS the comparison.
   Give route/taxonomy sub-pages descriptive names WITHOUT
   sequence numbers (`route-agent-based`, not `route-3-…`):
   renumbering later leaves stale references everywhere.
4. **Redistribute footnotes per page**: each sub-page carries
   only the `[^N]` definitions it cites (keep original
   numbers), `source_cnt` = its unique sources, and every
   section's coverage tag is recomputed from its actual
   citations (footnote-free sections → `low -- 0 sources`).
   Promote `###` children to `##` when they become top-level,
   and recompute the parent's accumulated N.
5. **Strip in-table footnotes during migration** — `[^N]` in
   table cells never renders; carry the citation in a lead-in
   sentence before the table instead.
6. **Finish**: update index.md (hub entry + one entry per
   sub-page), append log.md, and run the health check on ALL
   resulting pages — coverage tags, source_cnt, footnote
   definitions, and wikilink resolution all need re-verifying.

## Book Digest Workflow

Trigger: the user finished a book, exported highlights to
`source/books/<书名>.md` or `sources/books/<书名>.md`, and says
「开始 digest」. Also applies to any multi-page wiki ingest with
page-naming decisions. This is the book-source specialization of
`### Ingest` above.

### Plan First, Discuss Before Writing

The user requires the full modification plan BEFORE any wiki writes
for a book digest. Never start creating pages right after reading
the source. The plan must cover:

1. New pages — entity page + concept pages: name, content scope,
   tags for each
2. Chapter → page mapping — every highlighted chapter's fate: new
   page / enrich existing / fold into entity / merge with sibling
   chapters
3. Existing-page enrichment — which pages get enriched, with the
   source_cnt impact (1→2) spelled out
4. SCHEMA.md taxonomy extension — new 领域/子类 rows required
5. Tag normalization — if existing pages carry non-taxonomy English
   tags

Expect the user to EDIT the plan (drop / merge / rename pages) and
incorporate the edits verbatim — do not argue for the original names.

**Presenting the plan (CLI)**: deliver as PLAIN TEXT in the message
body, ending with numbered prose questions. Do NOT end the plan
message with a `clarify` tool call — in non-TUI/CLI clients the
dialog can hide the preceding plan text (happened 2026-08-03).
After the user's edits, restate the REVISED plan briefly, then
execute in one pass: entity → concepts → enrich → SCHEMA →
index/log → health check → report.

### Naming Decisions (user preferences)

- Concept pages take the concept name, not the chapter title:
  「为什么你不应该购买个股」→ `个股投资`
- The author's personal rules of thumb never get their own page:
  两倍法则 was dropped, kept as one line in the entity page's
  章节结构
- Concepts measuring the same thing merge into one page:
  4%法则 + 交叉点 → `财富自由`, formulas in LaTeX ($...$ / $$...$$)
- Pages are named around the thesis, not the vehicle: 个股与指数基金
  → `个股投资`, focused on why 选股很难 work
- Thin chapters fold into the entity page (芒格语录、时间资产) or
  into a sibling topic page (第十三+十六章 → `择时`; 第五+七章 →
  `储蓄`)
- Book entity page: Chinese-title filename, tag [书籍/理财]
  (books.base's hasTag("书籍") matches hierarchically), frontmatter
  author/pages/price/publisher/published_at/read_at
- Douban metadata goes into a standalone 「## 豆瓣元数据」 section at
  the END of the clippings file (workflow since 2026-08-03 — do NOT
  create `<书名>-豆瓣.md`); footnotes point at the clippings source
  itself (`[^1]: [[<书名>]]`), so the entity page's source_cnt is
  usually 1 (see references/book-entity-template.md; this supersedes
  the old "separate source file" practice)
- Page titles are English (2026-08 preference, established in the
  security/AI-engineering domains): new pages get an English
  `title` (`AppSec Remediation Bottleneck`, `Snyk Studio`) with the
  Chinese name in `aliases` (`[AppSec 修复瓶颈]`) — user's words:
  「wiki 总是英文，中文可以放在 aliases 里」. Chinese titles on
  legacy pages (`llm-zero-day-discovery`, `/security-review 命令`,
  investment book pages) are historical residue — propose
  normalization when passing by, never mass-rename unilaterally.
  Exception: new concept pages in the investment/finance domain
  keep Chinese filenames (2026-08-05《解读基金》digest: user
  explicitly chose Chinese, e.g. `开放式基金`, `基金净值`)

### Page Structure: Hierarchy First, No Flat Layout (user preference 2026-08-05)

The first-pass 《解读基金》digest was rejected as 「过于平铺，让人
抓不到重点」 and rebuilt under these rules (full before/after
walkthrough in references/解读基金-digest-example.md):

- **Sibling content groups under a parent section**: when ≥3
  sibling `##` sections exist, layer them as one `##` parent +
  `###` children. User's example: the two rebalancing strategies →
  `## 再平衡策略` + `### 积累型再平衡：买入低配资产` /
  `### 定投驱动的再平衡：切换定投标的` (child headings use colon +
  subtitle — they highlight the point better than a bare strategy
  name).
- **Narrow sub-topics get their own page**: if a sub-topic only
  merits a small section inside the parent but carries an
  independent thesis, create a standalone concept page and reduce
  the parent's mention to one natural sentence + bidirectional
  wikilink. Examples: FOF split out of `基金评价`; `波段操作`
  (user: 「它是一种特殊的择时」) split out of `择时`. Signal:
  variant / special form → own page.
- **Logic chain over source order**: organize by progression
  (现象→手段→后果→误区→根源; `基金净值` uses a five-part chain);
  evidence-style content gathers under a `## 数据证据` parent
  (`一次性投入与分批买入`: A 股回测 / 根因 / 美股数据).
- **Parent coverage = union of child footnotes**: a `##` parent
  with a coverage tag takes N = the union of all its `###` child
  footnotes (children citing [^1] and [^2] → parent
  `medium -- 2 sources`); each child is tagged by its own actual
  citations. Recompute N section by section after restructuring —
  do not reuse old values.
- **Give the page skeleton in the plan phase**: the digest plan
  must list each new page's 父节/子节 skeleton and the
  split-into-own-page list, so the user isn't asked to rework
  after the fact.

### Douban Metadata Fallback

The sandbox often cannot reach douban.com (DNS blackholed to
198.18.x). Ask the user to paste 出版社/ISBN/定价/页数/出版日期/评分
in chat. Mark missing fields as 待补充 in BOTH the source file and
the 书籍信息 table — never fabricate metadata.

### Vendor-Viewpoint Articles（供应商视角博客）

Established practice when digesting a vendor's own blog (e.g. the
Snyk position piece):

- Single-source treatment: external benchmarks cited inside the
  article (BaxBench, CodeRabbit, Veracode, etc.) still count as
  that ONE article source — all footnotes point at the article
  itself; no separate source or page is created for them
- Marketing content never gets pages: TL;DR, trial prompts,
  「What this means for you」, screenshots — skip all of it
- Sub-topics the user doesn't care about are omitted wholesale
  (the Snyk article's Evo/AI-stack security was dropped after the
  user said 「不是很关注」) — never pad for completeness
- One-sided comparisons (vendor product vs competitors) live as a
  comparison table INSIDE the entity page; do not build a synthesis
  page — synthesis needs ≥2 entities with independent sources; ask
  the user when in doubt
- Architecture arguments that overlap an existing concept page
  (e.g. ai-driven-sast's hybrid architecture) get one
  cross-reference line in the existing page instead of duplicated
  content

### Health Check on Many Pages: Tool-Call Cap False Positive

The portable health-check script reads each wikilink via the
read_file TOOL (≤3 calls per link); running it over 10+ pages in
one execute_code can hit the 50-tool-call cap and report false
❌ NOT FOUND for the LAST file checked.

- Before "fixing" a flagged page, re-verify with a tiny targeted
  script (read_file on the exact path) — the failure is usually the
  cap, not the page.
- For big batches, read files with `open(path).read()` inside
  execute_code instead of the read_file tool (no tool-call budget).

### Book-Digest Pitfalls

- Enriching an existing page (source_cnt 1→2): new inline [^N]
  citation + footnote definition at page bottom + frontmatter
  source_cnt + recompute coverage on affected sections (US-market
  section citing two sources → `medium -- 2 sources`)
- Clippings directory ambiguity: BOTH `source/` (singular) and
  `sources/` (plural) exist under the wiki root; new clippings may
  land in either (2026-08-05: 《解读基金》 landed in the singular
  `source/books/`, other books in the plural `sources/books/`).
  Glob BOTH directories before reading — never assume one;
  `[[书名]]` footnotes resolve by basename, unaffected by directory
- Tag normalization: [investment, asset-allocation, ...] →
  [investment, 投资/资产配置]; [behavioral-finance, cognitive-bias]
  → [behavioral-finance, 投资/行为金融]; update modified_at too
- index.md Chinese entries sort by pinyin — insert new entries at
  their pinyin position
- Page scale follows precedent: 《资产配置行动指南》digest = 1
  entity + 7 concepts
- NO second-person 「你」 in body text — rewrite rhetorical
  questions from the book too (「怎么知道自己是否擅长挑选个股？」→
  「选股者难以事先确认自己是否擅长」)
- Enriching old pages may surface historical gaps in the health
  check (0 wikilinks, illegal multi-tags) — fix them on the spot
  (cross-links, tag normalization), don't leave them; new pages
  must satisfy ≥2 inbound links from the start

### Book Digest Verification

1. Health check on ALL new/modified pages (see cap pitfall above)
2. Re-read log.md first ~12 lines after patching near frontmatter
3. Confirm index.md entries and SCHEMA.md taxonomy rows landed
4. Worked examples: references/持续买入-digest-example.md,
   references/解读基金-digest-example.md

## Pitfalls

- **Splitting a page: the hub must keep the original
  filename** — moving sections into `page-name/` sub-pages is
  fine, but the hub stays at the original path so inbound
  `[[page]]` links and `[[page#anchor]]` links keep resolving.
  Grep for `page#` anchors wiki-wide before deciding what may
  leave the hub.
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
- **V4A patch can swallow frontmatter `---`** — when a
  hunk's context includes a blank line adjacent to the
  frontmatter closing `---`, the fuzzy matcher may treat
  `---` as the blank line and replace it (log.md corrupts
  silently, YAML never closes). Anchor hunks on unique
  content lines (e.g. the first log entry) instead of
  blank-line context, and after any patch near frontmatter
  verify the `---` delimiter survives (read the first ~12
  lines of the file).
- **Entity page chapter-tracking checklist** — when adding
  a chapter to a book entity page, update: (a) table row,
  (b) `source_cnt`, (c) footnote definition, (d) coverage
  indicators if unique sources crossed a level threshold.
- **Source injection into existing pages** — when a new
  source enriches existing pages, update `source_cnt`, add
  `[^N]` refs and footnote definitions, and update every
  affected section's coverage indicator. When `[^N]` goes
  into a child `###` section, parent `##` sections with
  coverage tags accumulate ALL child footnotes — recompute
  the parent's N too (e.g. low 1 → medium 2), and re-run
  the health check after all fixes.
- **Standalone `[^N]` lines are FORBIDDEN** — footnotes
  MUST be inline at the end of a sentence or paragraph,
  never floating alone between elements.
- **Every inline `[^N]` needs a definition; every
  definition must be cited inline** — verify both
  directions independently after writing a page. (a)
  Inline citations without the page-bottom definition
  block make the health check report `source_cnt: 1`
  while computing `unique sources: 0` — the page is
  INVALID per SCHEMA. (b) Unused footnote definitions are
  the classic orphan. Multi-page ingests are where (a)
  slips through: the first page gets its definition, later
  pages (e.g. a concept page created alongside a cookbook)
  don't.
- **`[^N]` on heading lines is FORBIDDEN** — the coverage
  indicator (`[coverage: low -- 1 sources]`) belongs on
  the heading line; footnote references (`[^1]`) do NOT.
  Pattern: `## Section [coverage: low -- 1 sources]`
  followed by `Body text.[^1]`. Never:
  `## Section [coverage: low -- 1 sources][^1]`.
- **Tables and lists without footnotes cause predictable
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
  use `[[wikilinks]]` inside any fenced code block,
  including ```text``` architecture chain diagrams like
  `A → B → C` — the temptation is strongest there. Use
  bare filenames (`kubernetes-api-server`) so users can
  Ctrl-O navigate quickly, and link concepts in the
  surrounding prose. Use ASCII art or mermaid for showing
  structural relationships between pages.
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
  sections — convert pre-existing prose too (flag large edits
  to the user).
