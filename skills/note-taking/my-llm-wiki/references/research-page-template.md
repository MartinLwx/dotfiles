# Research-* Synthesis Page Template

Research pages live in `synthesis/` and are named
`research-<topic>.md`. They survey a research area by
categorizing approaches into distinct lines (路线/范式)
and comparing them.

## Page Structure

```
---
title: <Topic> 研究路线综述
tags: [<domain-tag>]
aliases:
  - <English alias>
  - <Chinese alias>
source_cnt: <N>
summary: <One-line overview of the research lines covered>
created_at: YYYY-MM-DD
modified_at: YYYY-MM-DD
---

## Summary [coverage: ... -- N sources]

One paragraph per research line, stating core idea + SOTA representative.
End with a **核心结论** paragraph: how the lines relate
(complementary vs competing), what the current SOTA is.

## 研究背景 [coverage: ... -- N sources]

### 为什么需要<这个领域> [coverage: ... -- N sources]
Motivation — why this research area matters. Concrete numbers/examples preferred.

### 关键概念区分 [coverage: ... -- N sources] (optional)
If the field has commonly confused terms (e.g., TDA vs RAG vs Search), a comparison table here helps.

## 核心技术挑战 [coverage: ... -- N sources]

One `###` subsection per challenge. Each challenge section:
- States the challenge
- Optionally notes how different research lines address it differently

Common challenge categories: scale, granularity, latency, determinism, evaluation.

## 研究路线 / 研究范式

One `###` subsection per research line. Each follows this shape:

```
### 路线N：<路线名称> [coverage: ... -- N sources]

**核心思想**：<One sentence>

**优势**：
- Bullet list of strengths

**劣势**：
- Bullet list of weaknesses

**SOTA 工作** / **代表工作**：
- **Work Name** (Authors, Year): one-line description
```

## 路线对比 / 范式对比

Comparison table with emoji annotations per SCHEMA.md conventions:

| 维度 | Line A | Line B | Line C | Line D |
|:----|:-----:|:-----:|:-----:|:-----:|
| 🔗 **机制** | ... | ... | ... | ... |
| ... | ... | ... | ... | ... |

### 👑 各维度最优

| 维度 | 最优路线 | 理由 |
|:----|:------|:---|
| ... | ... | ... |

## Current State [coverage: ... -- N sources]

One paragraph per research line summarizing current maturity.
End with future directions paragraph.

[^1]: [[Source Name]]
```

## Research Line Identification

When ingesting a single paper, the paper's Related Work
section is the primary source for identifying research
lines. Supplement with general domain knowledge only when
the paper's coverage is clearly incomplete.

Each research line must have:
1. Core idea (distinct from other lines)
2. At least one representative work cited in the source paper
3. Clear strengths and weaknesses relative to other lines

Avoid creating lines that are just "the paper being
ingested" — the research page should contextualize the
paper within the broader field.

## Comparison Table Rules

- Best per row gets 👑 (exactly one per row)
- Present/Capable → ✅
- Absent/Incapable → ❌
- Partial/Emerging → 🟡
- Inherited from components → —
- Cells with factual claims MUST carry inline footnotes
- Cells with only logical inference MUST NOT carry footnotes
