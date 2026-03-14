---
name: go
description: Use when the user has been sending buffered input via /wait-for-command and is now ready for Claude to process everything and execute the task
---

# Go — Execute Buffered Input

## Overview

**Buffer mode is over. Process all prior input and execute.**

The user has finished sending context/instructions across multiple turns. Now read everything they sent since `/wait-for-command` was invoked and act on it as a single combined request.

## Rules

1. **Treat all messages since `/wait-for-command`** as one unified input
2. **Determine the task** from the combined input and execute it fully
3. **If the combined input is ambiguous**, ask one clarifying question before proceeding
4. **Apply all relevant skills** as you normally would for the task at hand
