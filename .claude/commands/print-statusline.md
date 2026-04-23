---
description: Render current status line with segment-by-segment explanation
---

Read `/Users/phurin/.claude/statusline-command.sh` and show me exactly what the current status line renders. Format the answer as:

Line 1:
<rendered line 1 with example values>

Line 2:
<rendered line 2 with example values>

Line 3:
<rendered line 3 with example values>

Then, after the three rendered lines, add an "Explanation" section that walks through each line segment-by-segment in this style:

Line 1 (when in a git repo):
📁 repo:dotfiles | 🌿 branch:main | ❓?3
- 📁 `repo:` dim label, **bold white** repo name
- 🌿 `branch:` dim label, **bold cyan** branch name
- ❓ **bold yellow** `?N` uncommitted file count
- `|` separators in dim dark gray

Line 2:
<rendered>
- bullet per segment describing emoji, color, data source, and any conditional behavior

Line 3:
<rendered>
- bullet per segment with the same treatment

Use representative placeholder values where data depends on runtime state. Note fallback/placeholder behavior for each segment where applicable.
