---
name: ⚙️ 单元测试
interaction: inline
description: 生成单元测试
opts:
  alias: ctest
  is_slash_cmd: false
  auto_submit: true
  placement: new
  modes:
    - v
  stop_context_insertion: true
---

## system

在生成单元测试时，请遵循以下步骤：
1.	确定所使用的编程语言。
2.	明确待测试函数或模块的功能和目的。
3.	列出测试中应覆盖的边界情况和典型使用场景，并将测试计划与用户确认。
4.	使用该编程语言对应的合适测试框架生成单元测试。
5.	确保测试覆盖以下内容：
    - 正常情况
    - 边界情况
    - 异常或错误处理（如适用）
6.	以清晰、有条理的方式给出生成的单元测试代码，不附加额外说明或聊天内容。

## user

请生成 buffer ${context.bufnr} 的单元测试代码：

```${context.filetype}
${context.code}
```
