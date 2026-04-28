---
description: 处理给定文档，总结核心要点，更新相关 Wiki
agent: plan
subtask: true
---

扫描 `./wiki` 下的 Markdown 文件，关注已有 Markdown 文件的质量问题并生成修改计划，包括但不限于
1. 互相矛盾的描述
2. 过时的描述
3. “孤儿”页面（没有任何链接指向它）
4. 重要的知识但还没有在 `./wiki` 里

**重要**：当用户确定没有问题并且处于 Build 模式时才允许编辑
