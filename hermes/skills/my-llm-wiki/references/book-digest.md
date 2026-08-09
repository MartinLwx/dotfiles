# Book Digest Workflow

Trigger: the user finished a book, exported highlights to
`sources/books/<书名>.md`, and says 「开始 digest」. 
Also applies to any multi-page wiki ingest with page-naming 
decisions. This is the book-source specialization of
Ingest (`operations.md`).

## Plan First, Discuss Before Writing

The user requires the full modification plan BEFORE any wiki
writes for a book digest. Never start creating pages right after
reading the source. The plan must cover:

1. New pages — entity page + concept pages: name, content scope,
   tags for each
2. Chapter → page mapping — every highlighted chapter's fate: new
   page / enrich existing / fold into entity / merge with sibling
   chapters
3. Existing-page enrichment — which pages get enriched
4. SCHEMA.md taxonomy extension — new 领域/子类 rows required
5. Tag normalization — if existing pages carry non-taxonomy
   English tags
6. **Page skeleton** — each new page's 父节/子节 skeleton and the
   split-into-own-page list, so the user isn't asked to rework
   after the fact (see "Page Structure" below)

Expect the user to EDIT the plan (drop / merge / rename pages) and
incorporate the edits verbatim — do not argue for the original
names.

## Naming Decisions (user preferences)

- Concept pages take the concept name, not the chapter title:
  「为什么你不应该购买个股」→ `个股投资`
- The author's personal rules of thumb never get their own page:
  两倍法则 was dropped, kept as one line in the entity page's
  章节结构
- Concepts measuring the same thing merge into one page:
  4%法则 + 交叉点 → `财富自由`, formulas in LaTeX ($...$ / $$...$$)
- Pages are named around the thesis, not the vehicle: 个股与指数基金
  → `个股投资`, focused on why 选股很难 work
- Book entity page: Chinese-title filename, tag [书籍/理财]
  (books.base's hasTag("书籍") matches hierarchically), frontmatter
  author/pages/price/publisher/published_at/read_at
- Douban metadata goes into a standalone 「## 豆瓣元数据」 section at
  the END of the clippings file (workflow since 2026-08-03 — do NOT
  create `<书名>-豆瓣.md`); footnotes point at the clippings source
  itself (`[^1]: [[<书名>]]`), so the entity page's source_cnt is
  usually 1 (see references/book-entity-template.md; this
  supersedes the old "separate source file" practice)

## Page Structure: Hierarchy First, No Flat Layout (user preference 2026-08-05)

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

## Vendor-Viewpoint Articles（供应商视角博客）

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
  comparison table INSIDE the entity page; do not build a
  synthesis page — synthesis needs ≥2 entities with independent
  sources; ask the user when in doubt
- Architecture arguments that overlap an existing concept page
  (e.g. ai-driven-sast's hybrid architecture) get one
  cross-reference line in the existing page instead of duplicated
  content

## Book-Digest Pitfalls

- Tag normalization: [investment, asset-allocation, ...] →
  [investment, 投资/资产配置]; [behavioral-finance, cognitive-bias]
  → [behavioral-finance, 投资/行为金融]; update modified_at too
- index.md Chinese entries sort by pinyin — insert new entries at
  their pinyin position
- Enriching old pages may surface historical gaps in the health
  check (0 wikilinks, illegal multi-tags) — fix them on the spot
  (cross-links, tag normalization), don't leave them; new pages
  must satisfy ≥2 inbound links from the start
- Enriching an existing page changes coverage too — full 
  recompute rules in `health-check.md`

## Book Entity Chapter Tracking

- **Entity page chapter-tracking checklist** — when adding a
  chapter to a book entity page, update: (a) table row,
  (b) `source_cnt`, (c) footnote definition, (d) coverage
  indicators if unique sources crossed a level threshold.
- **Book entity page pattern** — use
  `references/book-entity-template.md` for book entity pages.

## Verification

1. Health check on ALL new/modified pages (see `health-check.md`
   for the tool-call cap pitfall)
2. Re-read log.md first ~12 lines after patching near frontmatter
3. Confirm index.md entries and SCHEMA.md taxonomy rows landed
