---
name: run
description: Use when the user wants to execute a terminal command directly via /run, e.g. /run open ., /run code ., /run npm run dev
---

# Run — Execute Terminal Command

## Overview

**Run the given command. No questions, no explanation.**

## Rules

1. **Parse the arguments** after `/run` as the full shell command
2. **Detect mode** using the rules below
3. **Execute via Bash tool** — show no extra commentary, just run it

## Mode Detection

```
/run --bg <command>   → force background
/run <command>        → auto-detect
```

**Auto-detect logic:**

| First token of command | Mode | Why |
|---|---|---|
| `open`, `code`, `cursor`, `subl`, `sublime`, `idea`, `webstorm`, `goland`, `pycharm`, `rider`, `fleet`, `zed` | background | GUI app — no terminal output needed |
| Everything else | foreground | Need to see output |

**`--bg` flag** overrides auto-detect and forces background mode. Useful for long-running foreground processes like dev servers:

```
/run --bg npm run dev
/run --bg uv run -m server
```

## Examples

```
/run open .              → Bash(run_in_background: true)  "open ."
/run code .              → Bash(run_in_background: true)  "code ."
/run npm run build       → Bash                           "npm run build"
/run uv run -m pytest    → Bash                           "uv run -m pytest"
/run --bg npm run dev    → Bash(run_in_background: true)  "npm run dev"
/run ls -la              → Bash                           "ls -la"
```

## Response

- **Foreground**: Show the command output, nothing else
- **Background**: Confirm briefly, e.g. "Running `npm run dev` in background."
