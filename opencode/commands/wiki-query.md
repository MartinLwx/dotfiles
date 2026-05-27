---
description: search in the wiki to answer the given user question
agent: plan
subtask: false
---

The user's question is $ARGUMENTS. To answer it, follow these steps:
1. Read `./wiki/index.md` and identify the 1–3 wiki pages most likely to contain the answer.
2. Read each selected page and draft an answer grounded in the specific facts they contain. Include proper citations so the user can trace where the information came from.
3. If your synthesized answer contains high-quality insights that are not yet captured in the wiki system, ask the user whether they would like to add them to the wiki.
    * If the answer is yes, choose one of the following:
        * Create a new synthesis page if the content is substantial and spans multiple concepts or entities.
        * Append the content to existing related wiki pages, typically as a new subsection. Do not forget adding converage indicators for the new subsection.
    * Regardless of which option you choose, append a new entry to `./wiki/log.md` and `./wiki/index.md` to document the changes.
    * If the answer is no, skip this step.

*Guidelines*
- Keep the answer concise.
- Use converage indicators *effectively*.
    - `[coverage: high]` -- trust this section, skip the raw files.
    - `[coverage: medium]` -- good overview, check raw sources for granular questions.
    - `[coverage: low]` -- read the raw sources listed in that section directly.

**IMPORTANT**: Always respond in Chinese.
