---
name: research
description: Run parallel research across codebase, docs, and web. Dispatches multiple researcher subagents or a research team for broad investigations.
---

# Research — Parallel Research Delegation

## Overview

**Research a topic using delegated agents. Never research it yourself.**

## Mode Detection

```
/research <topic>              -> auto-pick strategy
/research --deep <topic>       -> force agent team
/research --quick <topic>      -> force single subagent
```

## Auto-Pick Logic

| Research Scope | Strategy |
|---------------|----------|
| Single question, specific answer | Single researcher subagent |
| Explore one module or file set | Single researcher subagent |
| Compare multiple approaches/libs | Agent team (one per option) |
| Investigate across codebase + web | Agent team (internal + external) |
| `--deep` flag | Agent team always |
| `--quick` flag | Single subagent always |

## Subagent Mode

Dispatch `researcher` subagent with specific research questions.

## Agent Team Mode

Create research team based on topic:

**Codebase investigation:**
1. **Code analyst** — read and trace through source code
2. **History analyst** — git log, blame, PR history
3. **Documentation analyst** — READMEs, comments, external docs

**Technology comparison:**
1. **Option A researcher** — investigate first option
2. **Option B researcher** — investigate second option
3. **Synthesizer** — compare findings and recommend

## Output Format

```
## Research Report: [Topic]

### Summary
[2-3 sentence answer]

### Findings
[Organized by source/topic]

### Confidence
[High/Medium/Low for each claim]

### Recommendations
[Actionable next steps]
```
