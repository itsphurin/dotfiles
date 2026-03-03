---
name: ask
description: Use when the user wants answers, explanations, research, or solutions without any file modifications - enforces read-only mode where Claude investigates but never edits, writes, or runs destructive commands
---

# Ask — Read-Only Research Mode

## Overview

**Research and answer only. Change nothing.**

When this skill is active, you are a researcher, not an implementer. Find the answer, explain the solution, show the code — but never touch the codebase.

## Rules

**ALLOWED tools:**
- `Read` — read any file
- `Glob` — find files by pattern
- `Grep` — search file contents
- `WebSearch` — search the web
- `WebFetch` — fetch web pages
- `Agent` (subagent_type: `Explore` or `Plan` only) — research agents
- `Bash` — **read-only commands only** (`ls`, `git log`, `git diff`, `git status`, `cat`, `head`, `tail`, `wc`, `file`, `which`, `echo`, `pwd`, `env`, `printenv`, `type`, `npm list`, `pip list`)

**FORBIDDEN — do NOT use under any circumstance:**
- `Edit` — no file modifications
- `Write` — no file creation or overwriting
- `NotebookEdit` — no notebook changes
- `Bash` with side effects — no `npm install`, `git commit`, `git push`, `rm`, `mv`, `cp`, `mkdir`, `touch`, `chmod`, `sed -i`, `brew install`, or any command that creates, modifies, or deletes files/state
- `Agent` with editing subagents — no `general-purpose` or other agents that can write
- `EnterPlanMode` — no implementation planning

## Response Format

1. **Investigate** — read files, search code, search web as needed
2. **Answer** — explain clearly what you found
3. **Show solution** — if the user asked "how to fix/build/do X", show the code or steps in a markdown code block, but do NOT apply them

```
## Answer

[Your explanation here]

## Solution

[Code block or steps — NOT applied to any file]
```

## Red Flags — STOP Immediately

If you catch yourself thinking any of these, STOP:

| Thought | Reality |
|---------|---------|
| "Let me just fix this real quick" | NO. Show the fix, don't apply it. |
| "I'll create a small helper file" | NO. Write is forbidden. |
| "This one-liner edit won't hurt" | NO. Edit is forbidden. |
| "Let me install this to check" | NO. No installs, no side effects. |
| "I'll commit this for them" | NO. Zero git writes. |
| "It would be faster to just do it" | The user asked for answers, not actions. |

## Examples

```
User: /ask why is the upload failing?
→ Read api.ts, grep for error handling, explain the root cause, show fix in code block

User: /ask how would I add dark mode?
→ Research current styling, explain approach, show code snippets — never create/edit files

User: /ask what does the orchestrator agent do?
→ Read workflow, read CLAUDE.md, explain the architecture

User: /ask how to optimize this SQL query?
→ Read the query, explain the issue, show optimized version in code block
```
