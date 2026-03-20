---
name: use-agent-team
description: Force creating an agent team to handle the given task. Spawns multiple Claude Code instances that coordinate via shared task list and direct messaging. Use for complex work requiring inter-agent collaboration.
---

# Use Agent Team — Force Agent Team Creation

## Overview

**Create an agent team for this task. Do not use subagents or do the work yourself.**

When this skill is active, you MUST use TeamCreate to set up a coordinated team of Claude Code instances. You are the team lead.

## Prerequisites

Requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in env (already configured in settings.json).

## Rules

1. **Parse the task** from the user's message after `/use-agent-team`
2. **Design the team** — decide roles and number of teammates (3-5 is ideal)
3. **Create the team** via TeamCreate
4. **Assign tasks** with clear, specific prompts
5. **Coordinate** — monitor progress, synthesize results, handle conflicts
6. **Clean up** — shut down teammates and clean up when done

## Team Design Patterns

### Code Review Team (3 teammates)
- **Security reviewer**: focus on vulnerabilities, auth, input validation
- **Performance reviewer**: focus on efficiency, resource usage, scaling
- **Quality reviewer**: focus on readability, patterns, test coverage

### Feature Implementation Team (3-4 teammates)
- **Architect**: plan the approach, define interfaces (require plan approval)
- **Frontend implementer**: UI/component work
- **Backend implementer**: API/logic work
- **Test writer**: tests for all new code

### Investigation Team (3-5 teammates)
- **Hypothesis A**: investigate one possible cause
- **Hypothesis B**: investigate alternative cause
- **Devil's advocate**: challenge other teammates' findings

### Research Team (3 teammates)
- **Codebase analyst**: explore internal code
- **Documentation researcher**: check docs, READMEs, comments
- **External researcher**: search web for patterns, libraries, solutions

## Plugin-Aware Agent Selection

When spawning teammates, scan the Agent tool's available `subagent_type` list for **domain-specific plugin agents** (e.g. `plugin-name:agent-name`). Plugin agents are specialists — use them as teammates when the task matches their domain.

For example, instead of a generic "Backend implementer" teammate, spawn one using a plugin's Python specialist if the backend is Python. Instead of a generic "Security reviewer", use a plugin security specialist if available. Check the Agent tool's available `subagent_type` list for exact names (format: `plugin-name:agent-name`).

**Rule**: Always check available plugin agents first. Use them as teammate agent types when they match the task domain. Fall back to custom or built-in agents for general tasks.

## Task Assignment Guidelines

Each teammate should:
- Own **different files** (avoid edit conflicts)
- Have **5-6 tasks** each for productivity
- Receive **enough context** in their spawn prompt (teammates don't inherit your conversation)

## Coordination Rules

- Wait for teammates to finish before synthesizing
- If a teammate gets stuck, message them with guidance or redirect
- Use plan approval for risky changes
- Monitor via Shift+Down (in-process) or split panes

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll just use a subagent instead" | NO. The user asked for agent team. Create one. |
| "This doesn't need a team" | The user wants team coordination. Create one. |
| "Let me do some of the work myself" | Delegate everything to teammates. You coordinate. |
| "One teammate is enough" | Minimum 2 teammates. Otherwise use subagent. |

## Response Format

1. Announce the team structure you're creating
2. Create the team and spawn teammates
3. Monitor and coordinate until completion
4. Synthesize all results into a final report
5. Clean up the team
