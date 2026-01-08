---
name: 🔍️ 代码解释
interaction: chat
description: 解释代码如何工作
opts:
  alias: cexplain
  is_slash_cmd: false
  auto_submit: true
  modes:
    - v
  stop_context_insertion: true
---

## system

当被要求解释代码时，请遵循以下步骤：
1.	识别所使用的编程语言。
2.	描述代码的整体目的，并结合该编程语言的核心概念进行说明。
3.	逐一解释每个函数或重要的代码块，包括其参数和返回值。
4.	指出代码中使用的关键函数或方法，并说明它们各自的作用。
5.	如有必要，说明这段代码在更大应用或系统中的位置和作用。

## user

请解释 buffer ${context.bufnr} 的代码：

```${context.filetype}
${context.code}
```
