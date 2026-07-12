# Health Check Script (Portable)

When `references/audit.py` doesn't exist, use `execute_code` with this pattern to systematically
validate all coverage indicators instead of doing it manually line-by-line.

The script checks:
1. Every section's reported N vs. actual unique footnote references
2. Coverage level matches the N range (high≥5, medium∈[2,4], low≤1)
3. source_cnt matches unique footnote source documents
4. Footnote definitions are correctly parsed and counted

## Usage

```python
# In execute_code, adapt the file path:
from hermes_tools import read_file
import re

content = read_file("/path/to/target/page.md", limit=2000)
text = content["content"]
raw_lines = text.split("\n")

# Strip line number prefix added by read_file: "123|content" → "content"
lines = []
for rl in raw_lines:
    m = re.match(r'^\s*\d+\|(.*)', rl)
    if m:
        lines.append(m.group(1))
    else:
        lines.append(rl)

# Collect all sections with [coverage: ...] tags
sections = []
for i, line in enumerate(lines, 1):
    m = re.search(r'\[coverage:\s*(\w+)\s*--\s*(\d+)\s*sources?\]', line)
    if m:
        h_match = re.match(r'^(#{2,4})\s+', line)
        sections.append({
            "line": i, "level": m.group(1), "reported_n": int(m.group(2)),
            "heading": line.strip(),
            "h_level": len(h_match.group(1)) if h_match else None
        })

# For each section, count [^N] refs between it and the next section at same-or-higher level
for idx, s in enumerate(sections):
    start = s['line']
    end = len(lines)
    for j in range(idx + 1, len(sections)):
        if sections[j]['h_level'] is not None and sections[j]['h_level'] <= s['h_level']:
            end = sections[j]['line']
            break
    
    refs = set()
    for li in range(start - 1, end):
        refs.update(re.findall(r'\[\^(\d+)\]', lines[li]))
    
    actual_n = len(refs)
    ok = "✓" if actual_n == s['reported_n'] else "✗ MISMATCH"
    print(f"L{s['line']}: {s['level']} -- reported N={s['reported_n']}, actual N={actual_n} {ok}")

# Level vs N range check
for s in sections:
    n = s['reported_n']; l = s['level']
    if l == 'high' and n < 5: print(f"✗ L{s['line']}: high but N={n} < 5")
    elif l == 'medium' and (n < 2 or n > 4): print(f"✗ L{s['line']}: medium but N={n} not in [2,4]")
    elif l == 'low' and n > 1: print(f"✗ L{s['line']}: low but N={n} > 1")
    else: print(f"✓ L{s['line']}: {l} -- {n} sources")

# source_cnt check
defs = {}
for line in lines:
    m = re.match(r'\[\^(\d+)\]:\s*\[\[([^\]]+)\]\]', line)
    if m:
        defs[m.group(1)] = m.group(2)
print(f"\nsource_cnt should be: {len(set(defs.values()))}")
print(f"Unique sources: {set(defs.values())}")
```

# Additional Checks (run after the main script)

## 4. Banned footer sections

```python
# Check for banned footer patterns: 相关页面, 相关概念, See also, Related
banned_patterns = [
    r'^##\s+相关页面',
    r'^##\s+相关概念',
    r'^##\s+See also',
    r'^##\s+Related',
]
for line in lines:
    for pat in banned_patterns:
        if re.search(pat, line, re.IGNORECASE):
            print(f"✗ BANNED footer section: {line.strip()}")
```

## 5. Wikilink validity

```python
# Extract all [[wikilinks]] from body (before first footnote definition)
body_end = len(lines)
for i, line in enumerate(lines):
    if re.match(r'\[\^\d+\]:', line):
        body_end = i
        break
body = '\n'.join(lines[:body_end])

# Find inline wikilinks ([[page]] or [[page|display]])
wikilinks = set(re.findall(r'\[\[([^\]|#]+)', body))
print(f"Inline wikilinks ({len(wikilinks)}):")

# Verify each link points to an existing page
for link in sorted(wikilinks):
    # Try concept/, entity/, synthesis/ directories
    path = None
    for subdir in ['concept', 'entity', 'synthesis']:
        result = read_file(f"/llmwiki/wiki/{subdir}/{link}.md", limit=2)
        # read_file does NOT raise on missing files — it returns an error dict.
        # Check for the absence of the error key to confirm the file exists.
        # Use limit=2 (not 1) — limit=1 on frontmatter-starting files in execute_code
        # context can return total_lines: 0 even when the file exists (see pitfalls).
        if not result.get("error") and result.get("content", "").strip():
            path = f"{subdir}/"
            break
        # Also accept empty files with valid metadata (total_lines > 0, no error)
        if not result.get("error") and result.get("total_lines", 0) > 0:
            path = f"{subdir}/"
            break
    status = f"✅ ({path})" if path else "❌ NOT FOUND"
    print(f"  [[{link}]]: {status}")

existing_count = sum(1 for link in sorted(wikilinks)
    for subdir in ['concept', 'entity', 'synthesis']
    if not (r := read_file(f"/llmwiki/wiki/{subdir}/{link}.md", limit=2)).get("error"))

if existing_count < 2:
    print(f"✗ Only {existing_count} wikilinks to existing pages (need ≥ 2)")
else:
    print(f"✓ {existing_count} wikilinks to existing pages — OK")
```

## 6. Unused footnote definitions (definitions never cited in body)

A footnote defined at page bottom but never referenced inline inflates `source_cnt` silently.
The basic source_cnt check above compares against ALL definitions. This extra pass catches
definitions that exist but are never cited:

```python
# Identify which footnote numbers are actually cited in the body
inline_cited = set(re.findall(r'\[\^(\d+)\]', body))  # 'body' from wikilink check above
defined_nums = set(defs.keys())
unused = defined_nums - inline_cited
if unused:
    print(f"✗ Unused footnote definitions: {unused} — remove them or add inline citations")
```

## Pitfalls

- **CRITICAL**: `read_file()` returns lines prefixed with
  `LINENUM|` (e.g. `123|content`). Always strip this prefix
  with `re.match(r'^\\s*\\d+\\|(.*)', rl)` before running
  regex on line content. The script above handles this in
  the "Strip line number prefix" block.
- **CRITICAL**: `read_file()` does NOT raise exceptions on
  missing files — it returns a dict with an `"error"` key
  and `"total_lines": 0`. Do NOT use `try/except` to detect
  missing files. Check `result.get("error")` or
  `result.get("total_lines", 0) == 0` instead. The wikilink
  validity check (§5) uses this pattern.
- **Alternative when `read_file` unavailable**: use
  `execute_code` with `open(path).read()` — no prefix
  stripping needed. The check logic is identical.
- The regex `r'\\[\\^(\\d+)\\]:\\s*\\[\\[([^\\]]+)\\]\\]'`
  for footnote definitions assumes the format
  `[^1]: [[Source Name]]`. If the wiki uses a different
  format, adjust accordingly.
- Sections with no `[^N]` refs at all should report N=0,
  but the script only catches sections that HAVE a coverage
  tag. If a section is missing its tag entirely, this
  script won't flag it — that's a manual check.
- **Wikilink check only verifies `concept/`, `entity/`,
  `synthesis/` subdirectories**. Extend the `subdir` list
  if the wiki has additional page types.
- **The wikilink body-cutoff at `[^\\d+]:` is a
  heuristic** — it assumes footnote definitions start at
  the first `[^N]:` pattern. Pages that mention `[^N]` in
  code blocks or prose before the real footnote section may
  get a false cutoff. Verify visually if the wikilink count
  seems off.
- **Unused footnote definitions are a recurring mistake**:
  adding a source to the frontmatter and footnote list
  without actually citing it in the body. Always run check
  #6 after ingesting new sources into existing pages.
- **`read_file(limit=1)` edge case**: in `execute_code`
  context, `read_file(limit=1)` on newly-written files that
  start with `---` (frontmatter) can return
  `total_lines: 0` even when the file exists, because line
  1 may be filtered or processed differently. The wikilink
  validity check (§5) uses `limit=2` to avoid this —
  reading 2 lines ensures at least one non-frontmatter line
  is seen. If you see `❌ NOT FOUND` for a file you just
  wrote, bump `limit` to 2 before trusting the result.
