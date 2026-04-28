---
description: 处理给定文档，总结核心要点，更新相关 Wiki
agent: plan
subtask: false
---

阅读给定的文档 $ARGUMENTS，执行以下步骤
1. 和用户共同讨论文档的核心要点
2. 在 `./wiki/entity`、`./wiki/topics/` 和 `./wiki/synthesis` 下新增相关的 Markdown 文件
3. 修改 `./wiki/index.md`，往里面增加新的 Markdown 文件的索引
4. 根据新增的 Markdown 文件，修改和完善 `./wiki` 下所有相关的文件，特别注意描述冲突的场景
5. 修改 `./wiki/log.md`，格式是：`- [日期] ingest | 文档标题`

**重要**：当用户确定没有问题并且处于 Build 模式时才允许编辑文件
