---
name: use-agent-team
description: Create an agent team using TeamCreate for coordinated parallel work. Teammates share a task list, communicate directly with each other via SendMessage, and self-coordinate. Use when the user explicitly requests a team, wants multi-angle review, needs coordinated implementation across layers, or has competing hypotheses to investigate. Not for fire-and-forget delegation — use /use-subagent for those.
---

# Use Agent Team — TeamCreate Coordination

**You are the team lead. Do not do the work yourself — create a team and coordinate teammates.**

## How It Works

Agent teams use `TeamCreate` to create a team with a shared task list. This is fundamentally different from sub-agents:

| | Sub-agents (`Agent` tool) | Agent Teams (`TeamCreate`) |
|--|--|--|
| Communication | Report back to caller only | Teammates message each other directly |
| Coordination | Caller manages everything | Shared task list, self-coordination |
| Best for | Focused tasks, only result matters | Complex work requiring discussion and collaboration |

## Workflow

1. **Create the team** via `TeamCreate` with a descriptive `team_name`.
2. **Create tasks** via `TaskCreate` — these go into the team's shared task list.
3. **Spawn teammates** via `Agent` tool with `team_name` and `name` parameters.
4. **Assign tasks** via `TaskUpdate` with `owner` set to a teammate's name, or let teammates self-claim.
5. **Coordinate** — teammates message each other via `SendMessage`. Messages from teammates arrive automatically.
6. **Monitor** — check `TaskList` for progress. Use `SendMessage` to guide teammates.
7. **Shutdown** — send each teammate `SendMessage` with `{type: "shutdown_request"}`.
8. **Cleanup** — run `TeamDelete` after all teammates have shut down.

## File Ownership

Assign each teammate distinct files or directories — two teammates editing the same file leads to overwrites.

**When overlap is unavoidable:**
- If the shared file is central to both tasks, use **sequential task dependencies**: create tasks with `addBlockedBy` so one completes before the other starts.
- For incidental overlap, tell each teammate explicitly which files they own vs. read-only.

**Content migration** (moving code between teammates' files): coordinate in the spawn prompts — tell the source teammate to remove the code and the destination teammate to add it.

## Spawn Prompt Guidelines

Each teammate's prompt should include:
- Enough background context to work independently (teammates don't inherit your conversation)
- Specific files they own vs. read-only
- The team name so they can access the shared task list
- Style conventions or patterns to follow

## Model and Agent Selection

- `sonnet` for reviewers and researchers (judgment-heavy, read-only)
- `inherit` for implementers and debuggers
- `haiku` only for trivial lookups

Check the Agent tool's `subagent_type` list for domain-specific plugin agents — prefer them when they match the task domain.

## Team Design Patterns

### Fan-Out Team (N Parallel Workers)
The most common pattern. Each teammate does the same type of work on a different target.
- Examples: improving N skill files, reviewing N packages, migrating N modules
- Each teammate owns one target
- Minimal inter-agent communication needed

### Code Review Team
- **Security reviewer**: vulnerabilities, auth, input validation
- **Performance reviewer**: hot paths, resource usage, scaling
- **Quality reviewer**: readability, patterns, test coverage
- Reviewers can challenge each other's findings via `SendMessage`

### Feature Implementation Team
- **Architect**: plan approach, define interfaces — use `mode: "plan"` to require plan approval
- **Frontend implementer**: owns UI files
- **Backend implementer**: owns API/service files
- **Test writer**: owns test files — blocked until implementers scaffold
- Use task dependencies (`addBlockedBy`) for sequential phases

### Investigation Team
- **Hypothesis A**: investigate one possible root cause
- **Hypothesis B**: investigate an alternative cause
- Teammates actively challenge each other's theories via direct messaging
- Lead synthesizes findings into conclusion

## Coordination Protocol

- Teammates go idle between turns — this is normal. Send them a message to wake them up.
- Use `SendMessage` to redirect, provide context, or relay findings between teammates.
- Use task dependencies to enforce ordering without manual coordination.
- If a teammate gets stuck, message them with guidance.

## Handling Failures

If a teammate produces incorrect output, spawn a replacement with the original context plus what went wrong. If downstream tasks depend on the failed output, keep them blocked until the replacement completes.

## Resolving Disagreements

When teammates disagree (common in review and investigation teams):
1. **Factual conflicts**: verify against the codebase.
2. **Judgment calls**: weigh by assigned expertise. Present both perspectives to the user for the final call.
3. Never silently discard findings — if you override, state why.

## Cleanup

1. Send `{type: "shutdown_request"}` to each teammate via `SendMessage`.
2. Wait for all teammates to approve shutdown.
3. Review outputs for completeness and cross-teammate consistency.
4. Run `TeamDelete` to clean up team resources.
5. Synthesize results into a final report for the user.

## Red Flags

| Thought | Correction |
|---------|------------|
| "I'll just use sub-agents instead" | The user asked for a team. Use `TeamCreate`. |
| "This task is too small for a team" | If single file + single concern, tell user a team adds overhead and offer sub-agent instead. |
| "One teammate is enough" | Split the work — the point is parallel execution with coordination. |
| "Two teammates will edit the same file" | Use task dependencies to sequence them, or assign clear file ownership. |
