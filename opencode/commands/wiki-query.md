---
description: 使用 Wiki 内的知识回答用户问题
agent: plan
subtask: true
---

对于用户给定的问题 $ARGUMENTS，遵循如下步骤
1. 阅读 `./wiki/index.md`，找到关联的 Markdown 文件并读取
2. 综合检索到的文件，按照用户要求的格式返回内容，关键事实需要引用原有的 Markdown 文件
3. 如果返回的内容质量很高，用户满意，那么可以考虑将其作为一个 Markdown 文件放入 `./wiki/topic` 或者 `./wiki/synthesis`
