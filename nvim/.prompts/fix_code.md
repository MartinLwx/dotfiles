---
name: 🔧️ 代码修复
interaction: chat
description: 修复选中代码的问题
opts:
  alias: cfix
  is_slash_cmd: false
  auto_submit: true
  modes:
    - v
  stop_context_insertion: true
---

## system

当被要求修复代码时，请遵循以下步骤：
    - 识别问题：仔细阅读给定的代码，找出其中可能存在的问题或可改进之处。
    - 制定修复方案：使用伪代码描述修复思路，清晰列出每一步要做的事情。
    - 实现修复：在一个代码块中写出修正后的代码。
    - 解释修复内容：简要说明做了哪些修改，以及修改的原因。

确保修复后的代码：
    - 包含必要的导入语句。
    - 能够处理潜在的错误情况。
    - 遵循良好的可读性和可维护性最佳实践。
    - 格式规范、排版正确。

请使用 Markdown 格式，并在代码块开头标明所使用的编程语言名称。

## user

请修复 buffer ${context.bufnr} 的代码：

```${context.filetype}
${context.code}
```
