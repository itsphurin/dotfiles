---
name: explain-code
description: Explains code with visual diagrams and analogies. Use when explaining how code works, teaching about a codebase, or when the user asks "how does this work?", "explain this function", "what does this code do?", "walk me through this". Generates a professional HTML explanation page and opens it in the browser for easy reading. Use this skill whenever someone wants to understand specific code, even if they just point at a file or function.
---

# Explain Code

Generate a single-page HTML code explanation that helps a developer deeply understand a specific piece of code — a function, module, class, algorithm, or pattern. The output is a polished, visual HTML page opened in the browser.

This skill is for explaining **specific code** (a function, a module, a pattern). For whole-project architecture overviews, use `explain-codebase` instead.

## Process

### 1. Investigate the code

Before writing anything, thoroughly understand the code being explained.

- Read the target code and its surrounding context (imports, callers, callees)
- Identify the core purpose, inputs, outputs, and side effects
- Trace the execution flow — what happens step by step?
- Note edge cases, error handling, and non-obvious behavior
- Look at how other parts of the codebase use this code
- Identify which mental model or analogy would make this click for someone

### 2. Create `explain.html` in the project root

Include these sections (adapt based on what makes sense for the code):

1. **Title & Context** — what this code is, where it lives, and its role in the bigger picture. Show the file path and line range.

2. **The Analogy** — compare the code to something from everyday life. A good analogy makes the "aha" moment instant. Use a visual card with an icon/emoji that reinforces the metaphor.

3. **Visual Diagram** — a CSS/HTML-based diagram showing the flow, structure, or relationships. This replaces ASCII art — use colored boxes, arrows (CSS borders/pseudo-elements), and labels to show:
   - Data flow through the function
   - State transitions
   - Component relationships
   - Algorithm steps
   - Decision trees

4. **Step-by-Step Walkthrough** — the actual code with numbered annotations. Show the real code in a syntax-highlighted block, with each key line or section explained in a numbered callout beside or below it. Use color-coded step numbers that match the diagram.

5. **Key Concepts** — cards explaining the underlying patterns, data structures, or language features used. Only include what's needed to understand this specific code.

6. **Gotchas & Edge Cases** — common mistakes, misconceptions, or subtle behavior. Use warning-styled cards (yellow/orange accent) to make these stand out.

7. **See Also** (optional) — links to related functions, callers, or relevant docs if helpful.

### 3. Open in browser

```bash
open explain.html   # macOS
# xdg-open explain.html  # Linux
```

## Design System

Use the same dark theme as explain-codebase for visual consistency:

```css
:root {
  --bg: #0d1117;
  --surface: #161b22;
  --surface2: #1c2333;
  --border: #30363d;
  --text: #e6edf3;
  --text-muted: #8b949e;
  --accent: #58a6ff;
  --green: #3fb950;
  --orange: #d29922;
  --purple: #bc8cff;
  --pink: #f778ba;
  --cyan: #79c0ff;
  --red: #f85149;
  --teal: #39d353;
}
```

General styling rules:
- Dark background, high-contrast text
- Cards with `var(--surface)` background and `var(--border)` borders
- Colored left borders on cards to indicate type (blue=info, green=analogy, orange=warning, purple=concept)
- Code blocks with syntax highlighting using these CSS colors (no external dependencies)
- Responsive layout — works on any screen size
- Professional typography with clear hierarchy
- No external dependencies, no CDN links — everything self-contained

### Code Display Pattern

Show code with line numbers and highlighted regions:

```css
.code-block {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 1rem 1.25rem;
  font-family: 'SF Mono', 'Fira Code', 'Cascadia Code', monospace;
  font-size: 0.85rem;
  line-height: 1.8;
  overflow-x: auto;
}
.code-block .line-number {
  color: var(--text-muted);
  user-select: none;
  min-width: 2.5rem;
  display: inline-block;
  text-align: right;
  margin-right: 1rem;
}
.code-block .highlight-line {
  background: rgba(88, 166, 255, 0.1);
  border-left: 3px solid var(--accent);
  margin: 0 -1.25rem;
  padding: 0 1.25rem;
}
/* Syntax colors */
.code-block .keyword { color: var(--pink); }
.code-block .string { color: var(--green); }
.code-block .comment { color: var(--text-muted); font-style: italic; }
.code-block .function { color: var(--purple); }
.code-block .number { color: var(--cyan); }
.code-block .type { color: var(--orange); }
```

### Walkthrough Step Pattern

Each step links a code region to an explanation:

```html
<div class="step">
  <div class="step-header">
    <span class="step-num" style="background: var(--accent)">1</span>
    <span class="step-title">Parse the input arguments</span>
  </div>
  <div class="step-code">
    <!-- highlighted code snippet -->
  </div>
  <div class="step-explain">
    This extracts the raw arguments and validates them against the schema...
  </div>
</div>
```

```css
.step { margin-bottom: 1.5rem; }
.step-header { display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.5rem; }
.step-num {
  display: inline-flex; width: 1.5rem; height: 1.5rem; border-radius: 50%;
  align-items: center; justify-content: center;
  font-size: 0.75rem; font-weight: 700; color: var(--bg);
  flex-shrink: 0;
}
.step-title { font-weight: 600; font-size: 1rem; }
.step-explain {
  color: var(--text-muted);
  font-size: 0.9rem;
  line-height: 1.6;
  padding-left: 2.25rem;
}
```

### Diagram Pattern

Use CSS flexbox/grid to create flow diagrams instead of ASCII art:

```css
.diagram { display: flex; flex-direction: column; align-items: center; gap: 0.5rem; padding: 1.5rem; }
.diagram-node {
  background: var(--surface2);
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 0.6rem 1.2rem;
  font-size: 0.85rem;
  text-align: center;
  min-width: 140px;
}
.diagram-node.input { border-left: 3px solid var(--green); }
.diagram-node.process { border-left: 3px solid var(--purple); }
.diagram-node.output { border-left: 3px solid var(--orange); }
.diagram-node.decision { border-left: 3px solid var(--pink); border-radius: 4px; transform: rotate(0deg); }
.diagram-arrow {
  color: var(--text-muted);
  font-size: 1.2rem;
  line-height: 1;
}
/* For horizontal flows */
.diagram.horizontal { flex-direction: row; flex-wrap: wrap; justify-content: center; }
```

### Analogy Card Pattern

```css
.analogy-card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-left: 4px solid var(--green);
  border-radius: 8px;
  padding: 1.25rem 1.5rem;
  margin: 1.5rem 0;
}
.analogy-card .analogy-icon { font-size: 1.5rem; margin-bottom: 0.5rem; }
.analogy-card .analogy-title { font-weight: 600; font-size: 1.1rem; margin-bottom: 0.5rem; }
.analogy-card .analogy-text { color: var(--text-muted); line-height: 1.7; }
```

### Gotcha Card Pattern

```css
.gotcha-card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-left: 4px solid var(--orange);
  border-radius: 8px;
  padding: 1rem 1.25rem;
  margin: 0.75rem 0;
}
.gotcha-card .gotcha-label {
  color: var(--orange);
  font-weight: 700;
  font-size: 0.8rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 0.35rem;
}
```

## Adaptation

Match the explanation style to what the code actually does:

- **Pure function**: emphasize input→transform→output flow, show the data transformation visually
- **Stateful class**: show state diagram with transitions, highlight mutation points
- **Algorithm**: step-by-step visual execution with before/after state at each step
- **Event handler / callback**: show the event flow, what triggers it, what it affects
- **Config / declarative**: explain what each field controls, show the effect of each option
- **Recursive function**: show the call tree unfolding, base case vs recursive case

Keep explanations conversational. For complex concepts, use multiple analogies — one high-level ("it's like a...") and one precise ("specifically, it works by...").
