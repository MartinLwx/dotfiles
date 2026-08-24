# Book Entity Page Template

When creating a book entity page for a `books.base` board:

## Frontmatter

```yaml
---
title: <书名>
tags: [书籍/理财]
aliases: []
author: <作者名>
pages: <页数>
price: <定价数字>
publisher: <出版社>
published_at: <YYYY-MM>
read_at: <阅读日期 YYYY-MM-DD>
source_cnt: <N>
summary: <一句话总结>
created_at: <YYYY-MM-DD>
modified_at: <YYYY-MM-DD>
---
```

The custom fields (`author`, `pages`, `price`, `publisher`,
`published_at`, `read_at`) are picked up by the `books.base`
board for column display.

## Standard Sections

```
## 定义 [coverage: low/medium -- N sources]
## 核心思想 [coverage: low/medium -- N sources]
## 书籍信息 [coverage: low -- 1 source]    ← metadata table from Douban
## 章节结构 [coverage: low/medium -- N sources]
## 阅读信息 [coverage: low -- 1 source]
```

### 书籍信息 table

```markdown
| 项目 | 内容 |
|------|------|
| 书名 | ... |
| 作者 | ... |
| 出版社 | ... |
| 出版日期 | YYYY-MM |
| ISBN | ... |
| 页数 | N |
| 定价 | N 元 |
| 装帧 | ... |

数据来源：[^1] 评分 X.X（N 人评价）。
```

### 阅读信息 table

```markdown
| 项目 | 内容 |
|------|------|
| 阅读日期 | YYYY-MM-DD |
| 阅读状态 | 已读完 / 阅读中 |
| 来源 | 个人藏书 / Kindle / 微信读书 |
```

## Douban Metadata Source

Douban metadata is captured manually: ask the user for it
(pasted in chat), then write it into the frontmatter of the
single clipping file `sources/books/<book-title>.md`.

- A book has exactly ONE source page: the clipping file —
  frontmatter carries metadata, body carries highlights.
- Ask the user for the Douban metadata (书名, 作者, 译者,
  原作名, 出版社, 出版年, ISBN, 装帧, 定价, 豆瓣链接,
  评分); on receipt add them as frontmatter fields of the
  clipping file. No separate `-豆瓣.md` file is ever created.

## Base File

For the `books.base` board:

```yaml
filters:
  and:
    - file.hasTag("book")
properties:
  author:
    displayName: 作者
  tags:
    displayName: 标签
  pages:
    displayName: 页数
  price:
    displayName: 定价
  publisher:
    displayName: 出版社
  published_at:
    displayName: 出版日期
  read_at:
    displayName: 阅读日期
views:
  - type: table
    name: 阅读过的书籍
    order:
      - file.name
      - author
      - tags
      - pages
      - price
      - publisher
      - published_at
      - read_at
```

## Cross-referencing

Book entity pages should wikilink the concepts they cover
(e.g., `[[资产配置]]`, `[[心理账户]]`). Each concept page cites
back to the clippings source with `[[<book-title>]]`. This
forms a bidirectional graph.

## Pitfalls

- The clipping file `sources/books/<title>.md` is the ONE
  source document for the book: its frontmatter carries the
  Douban metadata, its body carries the highlights. No separate
  `-豆瓣.md` file is created; all sections cite `[[<title>]]`
  and `source_cnt` is 1.
- The `书籍信息` section has `coverage: low -- 1 source`
  (the clipping file), not medium, unless another source also
  confirms metadata facts.
- The `核心思想` section typically has `coverage: low -- 1
  source` (only clippings) since the ideas come from the
  book itself, not metadata.
- Custom frontmatter keys (author, pages, etc.) go between
  the standard AGENTS.md required fields and the first
  standard field (source_cnt). Order: title, tags, aliases,
  <custom fields>, source_cnt, summary, created_at,
  modified_at.
