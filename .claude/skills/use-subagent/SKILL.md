---
name: use-subagent
description: Delegate tasks to subagent(s) instead of doing the work directly. Use for parallel or specialized delegation — code review, research, implementation, debugging, testing.
---

# Use Subagent — Delegate, Don't Implement

**You are a coordinator.** Parse the task, dispatch subagent(s) via the Agent tool, and synthesize results.

## Workflow

1. Parse the user's task into subtasks
2. Choose agent type(s) per the decision table
3. Dispatch via Agent tool with a clear, scoped prompt
4. Synthesize and report results

## Agent Selection

First, scan the Agent tool's `subagent_type` list for a **plugin specialist** matching the task's language, framework, or domain. Plugin agents are preferred when available. Otherwise, fall back to:

| Task Type | Agent Type | Model | Notes |
|-----------|-----------|-------|-------|
| Code review | code-reviewer | sonnet | Read-only, quality-focused |
| Research / exploration | researcher | sonnet | Needs depth for complex analysis |
| Bug investigation | debugger | inherit | May need edit access for fixes |
| Code implementation | implementer | inherit | Needs write access |
| Write tests | test-writer | inherit | Needs write access |
| Simple lookup / summary | general-purpose | haiku | Only for trivial, fast tasks |

Use `haiku` only for simple, well-scoped lookups (e.g. "find which file defines X"). Default to `sonnet` for anything requiring judgment or synthesis.

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

Limit concurrent subagents to 3-4 — each consumes tokens and context, and results get harder to synthesize beyond that. For larger tasks, batch into waves.

## Background Dispatch

Set `run_in_background: true` when:
- You are dispatching 2+ agents and can continue useful work while they run
- The user does not need immediate results from a particular agent
- A task is long-running (large codebase scans, multi-file implementations)

This keeps you unblocked to dispatch more agents or prepare synthesis work.

## Worktree Isolation

Set `isolation: "worktree"` when a subagent will edit files that could conflict with other subagents or with your own ongoing work. Typical use: dispatching multiple implementers that touch overlapping directories. Read-only agents (reviewers, researchers) generally do not need isolation.

## Task Prompt Guidelines

Each subagent prompt should include:
- **Scope**: specific files, modules, or directories to target
- **Context**: error messages, constraints, relevant architecture details
- **Deliverable**: what to return (fix, report with severity, list of findings, etc.)

Bad: "Review the code"
Good: "Review src/auth/ for security vulnerabilities, focusing on token handling and session management. The app uses JWT in httpOnly cookies. Return issues with severity ratings."

## Error Handling

If a subagent returns incomplete or low-quality results, retry with a narrower scope or more specific prompt. If a `haiku` agent lacks depth, re-dispatch with `sonnet`. Do not silently accept poor results.

## Synthesizing Results

When multiple subagents return:
- Merge complementary findings into a unified report
- If findings conflict, note the disagreement and recommend which to trust based on evidence quality
- Keep the synthesis concise — the user wants conclusions, not a transcript

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll just do this myself quickly" | Dispatch a subagent. |
| "This is too simple for a subagent" | The user asked for delegation. Use it. |
| "Let me explore first, then dispatch" | Dispatch the exploration to a researcher. |
