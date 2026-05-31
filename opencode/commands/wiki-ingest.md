---
description: Process the given document and extract any concepts
agent: plan
subtask: false
---

You are an expert in knowledge extraction and wiki writing. Analyze the input document $ARGUMENTS and follow these steps:
1. Review the existing content in `./wiki/index.md` to learn what pages exist and their summaries.
2. Scan top 20-30 entries in `./wiki/log.md` to understand recent activity.
1. Identify 3 ~ 5 distinct and meaningful concepts/entities that are suitable as standalone wiki pages. Each concept/entity should represent a topic that someone might reasonably search for.
4. Present the extracted concepts/entities to the user and ask for feedback before proceeding.
5. For each confirmed concept/entity, create a detailed wiki page and save it under the `./wiki` directory. If related concepts or entities are referenced within a page, use [[Obsidian wikilinks]] to connect them.
6. Update `./wiki/index.md` by adding entries for any newly created pages.
7. Append a new record to the `./wiki/log.md` to document the changes.

**IMPORTANT**: Always respond in Chinese.
