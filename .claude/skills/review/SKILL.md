---
name: review
description: Run a parallel code review on recent changes or specified files. Auto-picks subagent for quick reviews or agent team for multi-perspective deep reviews.
---

# Review — Parallel Code Review

## Overview

**Review code changes using delegated agents. Never review code yourself.**

## Mode Detection

```
/review                    -> review git diff (unstaged + staged), auto-pick strategy
/review <file-or-dir>     -> review specific path
/review --deep             -> force agent team with 3 reviewers
/review --quick            -> force single subagent review
```

## Auto-Pick Logic

| Changes | Strategy |
|---------|----------|
| < 200 lines changed | Single code-reviewer subagent |
| 200-500 lines across 1-2 files | Single code-reviewer subagent |
| 200+ lines across 3+ files | Agent team (security + performance + quality) |
| `--deep` flag | Agent team always |
| `--quick` flag | Single subagent always |

## Subagent Mode

Dispatch `code-reviewer` subagent with:
- The diff or file paths to review
- Project conventions from CLAUDE.md if relevant

## Agent Team Mode

Create a 3-person review team:
1. **Security reviewer** — vulnerabilities, auth, secrets, injection
2. **Performance reviewer** — efficiency, memory, scaling, N+1 queries
3. **Quality reviewer** — readability, patterns, naming, test coverage

Each reviewer produces findings independently, then the lead synthesizes into a unified report.

## Output Format

```
## Code Review Summary

### Critical (must fix)
- [file:line] description

### Warnings (should fix)
- [file:line] description

### Suggestions (nice to have)
- [file:line] description
```
