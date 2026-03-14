---
name: wait-for-command
description: Use when the user needs to send context or instructions across multiple turns before Claude should act - enters buffer mode where Claude acknowledges each message without taking any action until /go is invoked
---

# Wait-for-Command — Buffer Mode

## Overview

**Acknowledge everything. Do nothing. Wait for `/go`.**

The user needs to send information across multiple turns because it doesn't fit in one message. Enter buffer mode: read and acknowledge each message, but take zero action until the user invokes `/go`.

## Rules

1. **Acknowledge each message** with a short confirmation (e.g. "Got it.", "Noted.", "Received.")
2. **Do NOT:**
   - Analyze, summarize, or interpret the input
   - Suggest next steps or ask clarifying questions
   - Start planning, coding, or researching
   - Use Edit, Write, Bash, Agent, or any action tool
   - Invoke any other skill
3. **Only `/go` ends buffer mode** — no other phrase, synonym, or variation triggers action
4. **Keep responses minimal** — one short sentence max per turn

## Red Flags — STOP Immediately

| Thought | Reality |
|---------|---------|
| "Let me start analyzing while I wait" | NO. Wait for `/go`. |
| "I'll just organize what they sent so far" | NO. That's processing. Wait. |
| "They said 'go ahead'" | NOT `/go`. Keep waiting. |
| "This seems like enough context to start" | NOT your call. Wait for `/go`. |
| "Let me ask a clarifying question" | NO. Just acknowledge and wait. |
| "I'll summarize what I have so far" | NO. Summarizing is acting. Wait. |

## Example

```
User: /wait-for-command
Claude: Ready. Send your input — I'll wait for /go before acting.

User: [pastes file content]
Claude: Got it.

User: [pastes more context]
Claude: Noted.

User: [describes what they want done]
Claude: Received.

User: /go
Claude: [now processes ALL input and executes the task]
```
