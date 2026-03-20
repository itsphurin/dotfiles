---
name: use-agent
description: Automatically choose the best delegation strategy (subagent or agent team) for the given task. Analyzes task complexity, parallelism needs, and inter-agent communication requirements to pick the optimal approach.
---

# Use Agent — Smart Delegation Router

## Overview

**Analyze the task and automatically choose between subagent(s) or an agent team.**

You are a delegation router. Evaluate the task, pick the best strategy, then execute it. Never do the work yourself.

## Decision Framework

Evaluate the task against these criteria:

### Use SUBAGENT when:
- Task is **focused and self-contained** (single concern)
- No **inter-agent communication** needed
- Work is **sequential** or has few parallel paths
- You need a **quick, focused result** (research, review, single fix)
- Task scope is **small to medium**
- Only the **result matters**, not the process

### Use AGENT TEAM when:
- Task has **3+ independent parallel tracks**
- Teammates need to **share findings and challenge each other**
- Work spans **multiple layers** (frontend + backend + tests)
- Task benefits from **competing hypotheses** (debugging)
- Task is **large and complex** (feature implementation, major refactor)
- **Coordination and discussion** between workers adds value

### Plugin-Aware Agent Selection

Before defaulting to custom agents, scan the Agent tool's available `subagent_type` list for **domain-specific plugin agents** (e.g. `plugin-name:agent-name`). Plugin agents are specialists — prefer them when the task matches their domain (language, framework, infrastructure, etc.). If no specialist matches, fall back to custom agents.

### Quick Decision Table

| Signal | Strategy |
|--------|----------|
| "review this file/PR" | Subagent (code-reviewer, or plugin specialist if domain-specific) |
| "fix this bug" | Subagent (debugger, or plugin specialist for the language/framework) |
| "research X" | Subagent (researcher, or plugin research agent) |
| "implement this small feature" | Subagent (implementer, or plugin language specialist) |
| "review from multiple angles" | Agent Team (review team) |
| "build this feature across frontend/backend" | Agent Team (implementation team, using plugin specialists per layer) |
| "investigate, could be several causes" | Agent Team (investigation team) |
| "refactor these 4 modules" | Agent Team (parallel workers, using plugin language specialists) |
| "research multiple topics and synthesize" | Agent Team (research team) |

## Execution

After deciding:

1. **Announce your decision**: "This task is best handled by [subagent/agent team] because [reason]."
2. **Execute the chosen strategy**:
   - If **subagent**: follow the /use-subagent skill behavior
   - If **agent team**: follow the /use-agent-team skill behavior
3. **Synthesize results** when delegation completes

## Override

If the user disagrees with your choice, switch immediately without argument.

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll just do this myself" | NO. Delegate to subagent or team. |
| "Neither approach fits" | One always fits. Subagent is the safe default. |
| "Let me explore first" | Dispatch a researcher subagent to explore. |
