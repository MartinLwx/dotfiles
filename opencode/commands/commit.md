---
description: 检视代码变更，创建 Commit Message，提交 Commit
agent: build
subtask: true
---

检视代码变更并创建合适的 Commit Message，遵循如下步骤
1. 使用 `git status` 命令查看当前已经 Stage 的文件
2. 使用 `git diff --staged` 命令检视已经 Staged 的文件的代码变更，如果有必要可以选择使用 read 工具阅读整个文件理解代码变更
3. 使用 `git log --oneline -5` 查看最近的 5 个 commit 都做了什么
4. 分析代码变更，最后创建一个简短的、描述性的 Commit Message，它应该遵循一定的惯例。专注于 why 而不是 what
5. 在最后提交之前 Commit 之前，向用户征询 Commit Message 的意见
6. 如果用户同意，那么就以刚才的 Commit Message 提交 Commit。否则就根据用户反馈的意见调整

**重点**：总是在用 `git commit` 正式提交 Commit 之前征询用户意见。基于代码变更解释你为何创建了提议的 Commit Message
