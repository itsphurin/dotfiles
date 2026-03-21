---
name: use-agent
description: Delegate any task using sub-agents or agent teams. Use this when asked to research, implement, review, debug, refactor, or handle multi-step work. Picks the right strategy — sub-agents (Agent tool) for focused fire-and-forget work, agent teams (TeamCreate) when workers need to coordinate and communicate with each other.
---

# Use Agent — Smart Delegation Router

Evaluate the task, pick the best delegation strategy, then invoke it via the Skill tool. Never do the work yourself.

## Decision Framework

**Choose based on the task, not a default.** Sub-agents are cheaper and faster but agent teams enable collaboration that sub-agents can't. Pick the one that fits the task's actual needs — don't force one over the other.

### Sub-agents (`Agent` tool) — when:
- Task is focused and self-contained (single concern)
- Workers don't need to talk to each other — only report results back to you
- Work is sequential or lightly parallel
- You need a quick, targeted result (research, review, single fix, small feature)

### Agent teams (`TeamCreate`) — when:
- Workers need to **share findings and challenge each other** (e.g., competing hypotheses)
- Task benefits from a **shared task list** where teammates self-claim work
- Work spans **multiple layers** that need coordination (frontend + backend + tests)
- Task has **sequential dependencies with ongoing coordination** (architect plans → implementers build → testers verify, with feedback loops between them)
- **Discussion and collaboration** between workers adds value

### Quick Decision Table

| Signal | Strategy |
|--------|----------|
| "review this file/PR" | Sub-agent |
| "fix this bug" | Sub-agent |
| "research X" | Sub-agent |
| "implement this small feature" | Sub-agent |
| "refactor a single module" | Sub-agent |
| "review from 3+ angles (security, perf, quality)" | Agent Team |
| "build feature across frontend/backend/tests" | Agent Team |
| "investigate with competing hypotheses" | Agent Team |
| "refactor 4+ modules in parallel with coordination" | Agent Team |
| "improve these N skills/files in parallel" | Agent Team (fan-out) |

### Hybrid Workflow (Research then Implement)

Some tasks need sequential phases with a simple result handoff (no ongoing discussion). Handle as chained sub-agent calls: dispatch a researcher, wait for results, then dispatch an implementer with those results. Upgrade to a team only if workers need to communicate back and forth during execution.

### Plugin-Aware Selection

Check the Agent tool's `subagent_type` list for domain-specific plugin agents. Prefer plugin specialists when they match the task domain.

## Execution

After deciding:

1. **Announce your decision**: "Using [sub-agent/agent team] because [one-line reason]."
2. **Invoke via Skill tool**:
   - Sub-agent: invoke the `/use-subagent` skill
   - Agent Team: invoke the `/use-agent-team` skill
3. **Synthesize results** when delegation completes.

## Override

If the user disagrees with your choice, switch immediately without argument.

## Red Flags

| Thought | Correction |
|---------|------------|
| "I'll just do this myself" | Delegate. Always. |
| "This might need a team" | Check: do workers need to talk to each other, share a task list, or challenge each other's findings? If yes → team. If no → sub-agent. |
| "Neither approach fits" | Re-read the decision criteria. One always fits — decide based on the task, not a default. |
| "Let me explore first" | Dispatch a researcher sub-agent to explore. |
