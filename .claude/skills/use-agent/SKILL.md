---
name: use-agent
description: Delegate any task using subagents or agent teams. Use this when asked to research, implement, review, debug, refactor, or handle multi-step work. Picks the cheapest effective strategy — subagent by default, team only when parallelism or cross-cutting coordination is genuinely needed.
---

# Use Agent — Smart Delegation Router

Evaluate the task, pick the best delegation strategy, then invoke it via the Skill tool. Never do the work yourself.

## Decision Framework

**Default to subagent.** Subagents are 3-5x cheaper and faster than agent teams. Only escalate to a team when the task genuinely requires parallel tracks or inter-agent discussion.

### Use SUBAGENT when:
- Task is focused and self-contained (single concern)
- No inter-agent communication needed
- Work is sequential or lightly parallel
- You need a quick, targeted result (research, review, single fix, small feature)
- Only the result matters, not cross-pollination of ideas

### Use AGENT TEAM when:
- Task has 3+ truly independent parallel tracks
- Teammates need to share findings or challenge each other's reasoning
- Work spans multiple layers that must stay coordinated (frontend + backend + tests)
- Task benefits from competing hypotheses (complex debugging)
- The coordination overhead is justified by the complexity

### Quick Decision Table

| Signal | Strategy |
|--------|----------|
| "review this file/PR" | Subagent |
| "fix this bug" | Subagent |
| "research X" | Subagent |
| "implement this small feature" | Subagent |
| "refactor a single module" | Subagent |
| "review from 3+ angles (security, perf, quality)" | Agent Team |
| "build feature across frontend/backend" | Agent Team |
| "investigate with 3+ independent hypotheses" | Agent Team |
| "refactor 4+ independent modules in parallel" | Agent Team |

### Hybrid Workflow (Research then Implement)

Some tasks need sequential phases — e.g., research a codebase first, then implement based on findings. Handle these as chained subagent calls: dispatch a researcher subagent, wait for results, then dispatch an implementer subagent with those results as context. Only upgrade to a team if the implementation phase itself has parallel tracks.

### Plugin-Aware Selection

Before creating custom agents, check the Agent tool's `subagent_type` list for domain-specific plugin agents. Prefer plugin specialists when the task matches their domain; fall back to custom agents otherwise.

## Execution

After deciding:

1. **Announce your decision**: "Using [subagent/agent team] because [one-line reason]."
2. **Invoke via Skill tool**:
   - Subagent: invoke the `/use-subagent` skill
   - Agent Team: invoke the `/use-agent-team` skill
3. **Synthesize results** when delegation completes.

### Background vs Foreground Dispatch

For long-running tasks where the user does not need to wait, dispatch in the background. Prefer background when the task is exploratory or the user is continuing other work. Use foreground when the user is blocked on the result.

## Override

If the user disagrees with your choice, switch immediately without argument.

## Red Flags

| Thought | Correction |
|---------|------------|
| "I'll just do this myself" | Delegate. Always. |
| "This might need a team" | Start with a subagent. Escalate only if complexity demands it. |
| "Neither approach fits" | One always fits. Subagent is the safe default. |
| "Let me explore first" | Dispatch a researcher subagent to explore. |
