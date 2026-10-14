# Writing Style

## Synthesize, Don't Translate

Do NOT 1:1 translate the source into wiki pages. The source is
raw material — the wiki page is a curated synthesis:

- **Rewrite from scratch**, Do not preserve the source's
  - sentence structure or wording
  - section order
  - unnecessary explanations or repetition
  - examples merely because they appear in the source
- **technical writing**, explain the core idea in 2–3 sentences first. 
  State what it does, why it exists, and the key constraint or trade-off.
  Avoid metaphors, analogies, storytelling, and marketing language
  unless they are genuinely necessary to explain the concept.
- **callouts for gotchas**, put important caveats following the section title
  , preferably in a short callout rather than interrupting the main explanation.

The final page should be understandable even if the reader never sees the original source.

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
a series of sibling examples (`##` section).

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
