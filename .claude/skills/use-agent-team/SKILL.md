---
name: use-agent-team
description: Spawn a coordinated team of background agents that work simultaneously and communicate with each other. Each teammate runs independently with designated file ownership. Use when the user explicitly requests a team, wants multi-angle review by separate specialists, needs coordinated parallel implementation across distinct parts of a codebase, or has N independent targets to process in parallel. Not for single-delegation tasks — use /use-subagent for those.
---

# Use Agent Team — Parallel Agent Coordination

**You are the team lead. Do not do the work yourself — spawn teammates and coordinate.**

## How It Works

Teammates are spawned via the `Agent` tool with `run_in_background: true`. Each runs as an independent Claude Code instance with no access to your conversation, so every spawn prompt must be self-contained.

- **Spawn**: `Agent` with `run_in_background: true` for each teammate.
- **Coordinate**: `SendMessage` to give guidance, redirect, or unblock running teammates.
- **Track**: Task list to monitor progress and completion.

## Steps

1. Parse the user's task and design the team (2-5 teammates).
2. Announce the team structure before spawning.
3. Spawn all teammates with detailed, self-contained prompts.
4. Monitor progress. Use `SendMessage` to course-correct if needed.
5. Wait for all to complete, then synthesize results.

## File Ownership

Assign each teammate distinct files or directories. Two teammates editing the same file causes merge conflicts and wasted work. When designing prompts, explicitly state which files each teammate may edit vs. read-only. Also specify which directories they may create new files in.

**When overlap is unavoidable:**
- If the shared file is central to the task (e.g., a config file both teammates need to modify), use **sequential execution**: spawn one first, wait for completion, then spawn the next with the updated file state.
- If the overlap is incidental (e.g., both need to add an import to an index file), use `isolation: "worktree"` on each teammate. After completion, verify changes merge cleanly and resolve any conflicts yourself.

**Content migration** (moving code from one teammate's file to another's): Coordinate in the spawn prompts. Tell the source teammate to remove the code, and the destination teammate to add it. Both prompts must reference the same content to avoid duplication or omission.

## Spawn Prompt Guidelines

Each teammate's prompt should include:
- **Repo path** and relevant file paths they own
- **Background context** sufficient to work independently (they cannot see your conversation)
- **Scoped goal** with concrete deliverables
- **File boundaries**: which files to edit, which to read-only, which directories for new files
- **Constraints**: what not to change, style conventions, patterns to follow

## Model and Agent Selection

- `sonnet` for reviewers and researchers (judgment-heavy, read-only)
- `inherit` for implementers and debuggers (needs write access)
- `haiku` only for trivial lookups

Check the Agent tool's `subagent_type` list for domain-specific plugin agents — prefer them when they match the task domain. Read-only teammates (reviewers, researchers) do not need `isolation: "worktree"`.

## Team Design Patterns

### Fan-Out Team (N Parallel Workers)
The most common pattern. Each teammate does the same type of work on a different target.
- Examples: improving N skill files, reviewing N packages, migrating N modules
- Each teammate owns one target (file or directory)
- Minimal coordination needed — spawn all at once, collect results
- Ensure teammates follow consistent conventions by including style guidance in each prompt

### Code Review Team
- **Security reviewer**: vulnerabilities, auth, input validation
- **Performance reviewer**: hot paths, resource usage, scaling
- **Quality reviewer**: readability, patterns, test coverage

### Feature Implementation Team
- **Architect**: plan approach, define interfaces — other teammates wait for this output
- **Frontend implementer**: owns UI files
- **Backend implementer**: owns API/service files
- **Test writer**: owns test files — starts after implementers scaffold

### Investigation Team
- **Hypothesis A**: investigate one possible root cause
- **Hypothesis B**: investigate an alternative cause
- **Synthesizer**: review both findings, challenge assumptions, propose conclusion

## Coordination Protocol

- After spawning, periodically check task list status.
- Use `SendMessage` when a teammate needs redirection, additional context, or when another teammate's output affects their work.
- If a teammate gets stuck, send corrective guidance rather than terminating.
- For sequential dependencies (e.g., architect before implementers), spawn the first, wait for completion, then spawn the rest with the first teammate's output in their prompts.

## Handling Failures

If a teammate completes but produces incorrect or incomplete output, spawn a replacement with the original prompt plus a description of what went wrong. Do not fix it yourself — you are the coordinator. If downstream teammates depend on the failed output, wait for the replacement before spawning them.

## Resolving Disagreements

When teammates produce conflicting recommendations:
1. **Factual conflicts**: verify against the codebase and adopt the correct position.
2. **Judgment calls**: weigh by assigned expertise (e.g., a security reviewer's stance on auth trumps a performance reviewer's). Present both perspectives and your recommendation to the user for the final call.
3. Never silently discard a teammate's findings — if you override, state why in the final report.

## Cleanup

Once all teammates finish:
1. Review each output for completeness and conflicts.
2. If using worktree isolation, verify changes merge cleanly.
3. Check cross-teammate consistency (e.g., did parallel workers follow the same patterns?).
4. Synthesize into a concise final report for the user.
5. Report any unresolved issues needing manual attention.

## Red Flags

| Thought | Correction |
|---------|------------|
| "I'll just do it myself with subagents" | The user asked for a team. Spawn teammates. |
| "This task is too small for a team" | If the task is a single file and single concern, tell the user a team adds overhead and offer a subagent instead. Only force a team if there are genuinely independent subtasks. |
| "One teammate can handle everything" | Split the work — the point is parallel execution. |
| "Two teammates will edit the same file" | Sequence them or use `isolation: "worktree"`. |
