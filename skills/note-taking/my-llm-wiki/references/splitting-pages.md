# Splitting an Oversized Page

When a page exceeds ~200 lines, split it into a hub + sub-pages.
Proven workflow (used for research-vulnerability-detection, 364
lines → hub + 6 sub-pages). Same principle as the SKILL.md
progressive-disclosure split: the hub keeps the original filename
and the navigation role.

1. **Hub keeps the original filename and path** — every inbound
   `[[page]]` link keeps resolving. Obsidian allows a folder and
   a same-named file to coexist; create sub-pages in
   `page-name/` and link them as `[[page-name/subpage]]`.
   Create sub-pages with `obsidian create path=wiki/<page-name>/<subpage>.md
   ... silent`.
2. **Search for anchor links first** — `obsidian search
   query="[[page#"` across the wiki: sections targeted by
   anchors must stay in the hub or the links break. If an
   anchored section must move, rewrite the link as
   `[[page-name/subpage#heading]]`.
3. **Organize by content nature, not source order**: single-topic
   depth → its own sub-page; cross-cutting comparison content
   (e.g. a "challenges and how each line addresses them" section)
   stays in the hub — it IS the comparison. Give route/taxonomy
   sub-pages descriptive names WITHOUT sequence numbers
   (`route-agent-based`, not `route-3-…`): renumbering later
   leaves stale references everywhere. Renaming an existing page:
   use `obsidian rename` — it rewrites inbound wikilinks across
   the vault; a file-tool `mv` orphans every link.
4. **Redistribute footnotes per page**: each sub-page carries
   only the `[^N]` definitions it cites (keep original numbers),
   `source_cnt` = its unique sources, and every section's coverage
   tag is recomputed from its actual citations (footnote-free
   sections → `low -- 0 sources`). Promote `###` children to `##`
   when they become top-level, and recompute the parent's
   accumulated N.
5. **Strip in-table footnotes during migration** — `[^N]` in
   table cells never renders; carry the citation in a lead-in
   sentence before the table instead.
6. **Finish**: update index.md (hub entry + one entry per
   sub-page; mid-file insert → `read` + `create overwrite`),
   prepend log.md, and run the health check on ALL resulting
   pages — coverage tags, source_cnt, footnote definitions, and
   wikilink resolution (CLI: `obsidian unresolved`) all need
   re-verifying.
