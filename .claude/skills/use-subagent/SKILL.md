---
name: use-subagent
description: Force using subagent(s) to handle the given task. Dispatches work to specialized sub-agents running in isolated context windows. Use when you want focused, parallel delegation without agent team overhead.
---

# Use Subagent — Force Subagent Delegation

## Overview

**Delegate the task to subagent(s). Do not do the work yourself.**

When this skill is active, you MUST use the Agent tool to dispatch work. You are a coordinator, not an implementer.

## Rules

1. **Parse the task** from the user's message after `/use-subagent`
2. **Choose agent type(s)** based on the task (see Decision Table)
3. **Dispatch via Agent tool** — write a clear, specific task prompt
4. **Report results** — summarize what the subagent(s) found or did

## Agent Selection

### Step 1: Check for a specialized plugin agent

Before using a generic agent, scan the Agent tool's available `subagent_type` list for a **domain-specific match**. Plugin agents (e.g. `plugin-name:agent-name`) are specialists — prefer them when the task falls squarely in their domain.

**Selection logic:**
1. Identify the task's **language, framework, or domain** (e.g. TypeScript, Kubernetes, security audit)
2. Scan available agent types for a specialist that matches (e.g. `plugin-name:typescript-pro`, `plugin-name:kubernetes-specialist`)
3. If a specialist exists → use it via `subagent_type: "plugin-name:agent-name"`
4. If no specialist matches → fall back to custom agents below

### Step 2: Fall back to custom agents

| Task Type | Agent Type | Model | Why |
|-----------|-----------|-------|-----|
| Code review | code-reviewer | sonnet | Read-only, quality-focused |
| Bug investigation | debugger | inherit | Needs edit access for fixes |
| Research / exploration | researcher | haiku | Fast, read-only |
| Code implementation | implementer | inherit | Needs write access |
| Write tests | test-writer | inherit | Needs write access |
| General / unclear | general-purpose | inherit | Full capability |

## Parallel Dispatch

If the task has **independent subtasks**, dispatch multiple subagents in parallel:

```
Task: "Review auth module and write tests for the API"
-> Dispatch code-reviewer for auth module (parallel)
-> Dispatch test-writer for API tests (parallel)
-> Synthesize results when both complete
```

If subtasks are **dependent**, dispatch sequentially:

```
Task: "Find the bug in auth, then fix it"
-> Dispatch researcher to investigate (first)
-> Dispatch debugger with findings to fix (second)
```

## Task Prompt Guidelines

Write specific prompts for each subagent. Include:
- **What** to do (specific files, modules, or scope)
- **Context** the subagent needs (error messages, requirements, constraints)
- **Expected output** (report format, deliverables)

Bad: "Review the code"
Good: "Review src/auth/ for security vulnerabilities. Focus on token handling and session management. The app uses JWT in httpOnly cookies. Report issues with severity ratings."

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll just do this myself quickly" | NO. Dispatch a subagent. |
| "This is too simple for a subagent" | The user asked for subagent delegation. Use it. |
| "Let me explore first, then dispatch" | Dispatch the exploration to a researcher subagent. |

## Response Format

1. Announce which subagent(s) you're dispatching and why
2. Dispatch via Agent tool
3. After completion, provide a brief synthesis of results
