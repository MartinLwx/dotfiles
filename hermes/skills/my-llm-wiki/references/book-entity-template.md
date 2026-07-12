# Book Entity Page Template

When creating a book entity page for a `books.base` board:

## Frontmatter

```yaml
---
title: <书名>
tags: [book, <domain-tags>]
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

Save Douban metadata as a separate source file:
- Path: `sources/documents/<book-title>-豆瓣.md`
- Content: title, author, publisher, year, ISBN, pages, binding, price, rating, URL, 内容简介, 作者简介
- Footnote target: `[^1]: [[<book-title>-豆瓣]]`

This keeps the Douban data out of the clippings source file
(which lives under `sources/books/`) and provides a clean
footnote target for metadata-only facts.

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

- Don't put all metadata in the clippings source — keep
  Douban metadata in a separate file so `source_cnt`
  accurately reflects what each page draws from.
- The `书籍信息` section has `coverage: low -- 1 source`
  (only Douban), not medium, unless the clippings also
  confirm metadata facts.
- The `核心思想` section typically has `coverage: low -- 1
  source` (only clippings) since the ideas come from the
  book itself, not Douban.
- Custom frontmatter keys (author, pages, etc.) go between
  the standard AGENTS.md required fields and the first
  standard field (source_cnt). Order: title, tags, aliases,
  <custom fields>, source_cnt, summary, created_at,
  modified_at.
