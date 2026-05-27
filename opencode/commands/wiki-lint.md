---
description: run health checks on the wiki system to find issues
agent: plan
subtask: false
---

Perform these health checks

## Check 1 - Incorrect coverage level mapping

You can use the following three ripgrep commands to find the violations:

```sh
# high: N >= 5
$ rg -nP '\[coverage: high -- [0-4] sources?\]'

# medium: 2 <= N <= 4
$ rg -nP '\[coverage: medium -- (0|1|[5-9]|\d{2,}) sources?\]'

# low: N <= 1
$ rg -nP '\[coverage: low -- ([2-9]|\d{2,}) sources?\]' 
```

If the `rg` is absent, fallback to `grep` (the cli flags may vary).

*Action*: Correct each one by the coverage indicator rules.

## Check 2 - Orphan source

Find orphan source document with Obsidian CLI. The detail command is

```sh
$ obsidian orphans | rg "^sources/.*"
```

If the `obsidian` is absent, tell the user that he/she should enable it in the Obsidian settings.

*Action*: Delete them with `obsidian delete path=path/to/file` command one by one after the user confirms your plan. Do not use `rm` command

## IMPORTANT

- Respond in Chinese.
- Present a brief and structured summary on the issues identified. Also shows the actions for each check.
- Only execute actions after the user enables the Build mode manually and confirm the actions.
- If the user accept your proposed changes, re-run the checks to make sure the issues are gone.
