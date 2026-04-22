---
name: use-subagent
description: Delegate tasks to sub-agent(s) via the Agent tool. Sub-agents run independently, report results back to you, and cannot communicate with each other. Use for focused, fire-and-forget delegation — code review, research, implementation, debugging, testing. Not for coordinated team work — use /use-agent-team for that.
---

# Use Subagent — Fire-and-Forget Delegation

**You are a coordinator.** Parse the task, dispatch sub-agent(s) via the `Agent` tool, and synthesize results. Sub-agents report back to you only — they cannot message each other.

## When to Use Sub-agents vs Agent Teams

| Need | Use |
|------|-----|
| Focused task, only the result matters | Sub-agent (`Agent` tool) |
| Workers need to discuss and coordinate | Agent team (`TeamCreate`) |
| Quick research or single review | Sub-agent |
| Multi-angle review with cross-challenging | Agent team |

## Workflow

1. Parse the user's task into subtasks
2. Choose agent type(s) per the selection table
3. Dispatch via `Agent` tool with a clear, scoped prompt
4. Synthesize and report results

## Agent Selection

First, check the Agent tool's `subagent_type` list for a plugin specialist matching the task's domain. Otherwise, fall back to:

| Task Type | Agent Type | Model | Notes |
|-----------|-----------|-------|-------|
| Code review | code-reviewer | sonnet | Read-only, quality-focused |
| Research / exploration | researcher | sonnet | Needs depth for complex analysis |
| Bug investigation | debugger | inherit | May need edit access for fixes |
| Code implementation | implementer | inherit | Needs write access |
| Write tests | test-writer | inherit | Needs write access |
| Simple lookup / summary | general-purpose | haiku | Only for trivial, fast tasks |

Use `haiku` only for simple lookups (e.g. "find which file defines X"). Default to `sonnet` for anything requiring judgment.

## Parallel vs Sequential Dispatch

Dispatch in **parallel** when subtasks are independent:

```
"Review auth module and write tests for the API"
-> code-reviewer for auth module  (parallel)
-> test-writer for API tests      (parallel)
-> Synthesize when both complete
```

Dispatch **sequentially** when outputs feed into the next step:

```
"Find the bug in auth, then fix it"
-> researcher to investigate  (first)
-> debugger with findings     (second, using first result)
```

Limit concurrent sub-agents to 3-4 — each consumes tokens and context, and results get harder to synthesize beyond that.

## Background Dispatch

Set `run_in_background: true` when:
- You are dispatching 2+ agents and can continue useful work while they run
- The user does not need immediate results
- A task is long-running (large codebase scans, multi-file implementations)

## Worktree Isolation

Set `isolation: "worktree"` when a sub-agent will edit files that could conflict with other sub-agents or ongoing work. Read-only agents (reviewers, researchers) do not need isolation.

## Task Prompt Guidelines

Each sub-agent prompt should include:
- **Scope**: specific files, modules, or directories
- **Context**: error messages, constraints, architecture details
- **Deliverable**: what to return (fix, report with severity, list of findings)

Bad: "Review the code"
Good: "Review src/auth/ for security vulnerabilities, focusing on token handling and session management. The app uses JWT in httpOnly cookies. Return issues with severity ratings."

## Error Handling

If a sub-agent returns incomplete or low-quality results, retry with a narrower scope or more specific prompt. If a `haiku` agent lacks depth, re-dispatch with `sonnet`.

## Synthesizing Results

When multiple sub-agents return:
- Merge complementary findings into a unified report
- If findings conflict, note the disagreement and recommend which to trust based on evidence quality
- Keep the synthesis concise — the user wants conclusions, not a transcript

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll just do this myself quickly" | Dispatch a sub-agent. |
| "This is too simple for a sub-agent" | The user asked for delegation. Use it. |
| "Let me explore first, then dispatch" | Dispatch the exploration to a researcher. |
| "These workers need to talk to each other" | Use `/use-agent-team` with `TeamCreate` instead. |
