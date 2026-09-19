# Writing Style

## Synthesize, Don't Translate

Do NOT 1:1 translate the source into wiki pages. The source is
raw material — the wiki page is a curated synthesis:

- **Restructure by conceptual relevance**, not source section
  order.
- **Key takeaways go at the TOP** — put a informational summary
  using callout at the top, such as gotchas/limitations
- **Cut and consolidate** — if paragraphs can be replaced by a
  3-line summary + code block, use the latter.
- **Examples: few but essential** — do not copy the examples in
  the source if they are lengthy and unrepresentive. Always try
  to abstract the details and write generic examples.

## Natural Wikilink Placement

Wikilinks should be integrated naturally into the prose when 
the linked concepts are relevant. Do not add standalone sentences
or parenthetical notes solely to introduce Wikilinks.

- ✅️ Good: The LLM use [[transformer]] blocks with [[multi-head-attention]]
  to capture relationship between tokens.
- ❌️ Bad: The model uses Transformer blocks (see [[transformer]]) with 
  Multi-Head Attention (see [[multi-head-attention]]) to capture 
  relationships between tokens.

## Code Annotation for Cross-Framework Tutorials

Annotate code with emoji markers:

| Emoji | Meaning | Use |
|:---|:---|:---|
| 🔑 | Key API / entry point | The most critical framework call — read this line if nothing else |
| ⚠️ | Pitfall / gotcha | Easy mistakes: numerical instability, silent failures, non-intuitive behavior |
| 💡 | Principle / technique | Underlying mechanism or useful trick worth understanding |

**Code block rules**:

1. 1–2 sentence lead-in before each code block explaining what
   it does and what to focus on.
2. Prefer code comments in separate lines with `# 🔑` / `# ⚠️` / `# 💡`.
   The user may see the wiki page in mobile.
3. Comments must explain **why this line matters**
4. Explain key API parameters — don't assume framework
   familiarity.

## Code Example Organization

Code examples must be organized by logic — never laid out flat as 
a series of sibling examples in the top-level.

Group code examples under one `##` section if they are related.
Be specific in the title s.t. the user can know what the code
does at a glance.

Sort the code examples from easy to hard.

## Language Policy

Always respond to the user and write wiki page content in the
user's language.

Technical terms should be kept in their original form (English or
otherwise).

Wiki page content (body text, headings, callouts) should be in
the user's language. **Filenames and frontmatter keys are in
English (kebab-case)** — the single authoritative rule. The ONLY
exception: book entity pages use the Chinese book title as
filename (`references/book-digest.md`).

## Chinese Writing Conventions

- **Bold only, no italics** — Chinese typography does not use
  italics for emphasis; italics read as foreign/translation-ese.
  Use `**加粗**` for emphasis; never `*斜体*` / `_斜体_` for
  labels, emphasis, or terminology.

## Markdown Detail Rules

- **Math formulas in `$...$`** — `$O(\log n)$`, not
  `` `O(log n)` ``. Code identifiers use backticks.
- **Nested list indentation is 4 spaces** — for both ordered and
  unordered lists.
- **Scannable distributions: bullets, not prose** — enumerable
  data (percentage distributions, rankings, granularity/usage
  breakdowns) must be bullet lists or tables.
