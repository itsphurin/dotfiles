---
name: explain-codebase
description: Use when the user wants to understand a codebase's architecture, tech stack, or data flow - generates a professional HTML architecture page and opens it in the browser. Triggers on requests like "explain this project", "show me the architecture", "what does this codebase do", "how does this repo work", "onboard me to this codebase". Use this skill whenever someone wants a visual overview of a project, even if they just say "what is this".
---

# Explain Codebase

Generate a single-page HTML architecture visualization that helps a developer who just pulled the repo understand both **what the project does** and **how to work with it**.

## Process

### 1. Investigate the project

Read broadly before writing anything — the HTML must reflect the actual project, not a template.

- Read `pyproject.toml`, `package.json`, `Cargo.toml`, `go.mod`, or equivalent for dependencies and project metadata
- Glob for source files across all top-level directories (skip `.venv`, `node_modules`, `target`, `dist`, etc.)
- Read key entry points, config files, and core modules to understand the architecture
- Check for existing docs (`README.md`, `CLAUDE.md`, `AGENTS.md`, `.env.example`) for additional context
- Identify: tech stack, module boundaries, data flow, external integrations, CLI commands, environment setup
- Map each directory to its architecture layer (entry, command, service, infra, model, config, input, output) — these layer assignments drive consistent color-coding across the Component Architecture diagram and the Project Structure tree

### 2. Create `architecture.html` in the project root

Include these sections (adapt naming and content to what makes sense for the project):

1. **Quick Start** — the 3-5 commands to get the project running. See "Quick Start pattern" below.

2. **Tech Stack** — card grid of key dependencies with their roles and versions.

3. **Component Architecture** — layered diagram showing how modules connect (inputs, entry points, orchestrators, services, infrastructure, external systems, outputs). Use color-coded left borders per layer.

4. **Data Flow** — numbered step-by-step pipeline showing how data moves through the system, from input to output.

5. **Data Models / Key Abstractions** — cards showing the main domain types, their fields and types. Skip this if the project has no clear domain models.

6. **Project Structure** — interactive annotated file tree. See "Project Structure pattern" below.

7. **Common Tasks** — a table or list showing "If you want to do X, modify Y". This helps new developers navigate the codebase for real work.

8. **Configuration** — document environment variables, config files, and their purpose. Reference `.env.example` if it exists.

### 3. Open in browser

```bash
open architecture.html   # macOS
# xdg-open architecture.html  # Linux
```

## Component Patterns

### Quick Start pattern

Render as a single block (matching the project structure style) with colored step numbers, green commands, and muted hints. Each step is a row inside one container — not separate cards.

Structure each step as:
- **Step header line**: colored number badge + bold title (sans-serif) + optional right-aligned note (italic, muted)
- **Command line**: `$` prompt (muted, `user-select: none`) + command (green) + flags in a distinct color (cyan)
- **Hint line** (optional): muted italic sans-serif text for extra context
- **Separator**: subtle `1px` line between steps (`opacity: 0.5`)

```html
<div class="qs-block">
  <!-- One step -->
  <div class="qs-line qs-step">
    <span><span class="num" style="background:var(--accent)">1</span>
      <span class="step-text">Install dependencies</span></span>
    <span class="step-note">requires uv</span>
  </div>
  <div class="qs-line qs-cmd">
    <span><span class="prompt">$</span> <span class="cmd">uv sync</span></span>
  </div>
  <div class="qs-sep"></div>
  <!-- next step... -->
</div>
```

Key CSS:
```css
.qs-block {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 0.5rem 0;
  font-family: 'SF Mono', 'Fira Code', monospace;
  font-size: 0.85rem;
}
.qs-line { display: flex; align-items: baseline; padding: 0.2rem 1.25rem; line-height: 1.8; }
.qs-step .num {
  display: inline-flex; width: 1.3rem; height: 1.3rem; border-radius: 50%;
  align-items: center; justify-content: center;
  font-size: 0.72rem; font-weight: 700; color: var(--bg);
}
.qs-step .step-text { font-weight: 600; font-family: sans-serif; }
.qs-step .step-note { margin-left: auto; color: var(--text-muted); font-style: italic; font-family: sans-serif; }
.qs-cmd { padding-left: 2rem; }
.qs-cmd .prompt { color: var(--text-muted); user-select: none; }
.qs-cmd .cmd { color: var(--green); }
.qs-cmd .flag { color: var(--cyan); }
.qs-hint { padding-left: 2rem; color: var(--text-muted); font-style: italic; font-family: sans-serif; font-size: 0.82rem; }
.qs-sep { height: 1px; background: var(--border); margin: 0.4rem 1.25rem; opacity: 0.5; }
```

### Project Structure pattern

The file tree uses **flexbox rows** (not `<pre>` with embedded whitespace) so that descriptions right-align to the container edge. Directory names are colored to match their architecture layer in the Component Architecture diagram — this visual link helps developers connect "where is it" to "what role does it play".

Include an interactive legend above the tree. Hovering a legend item dims all non-matching rows and adds a colored left border to matching rows. This uses a small `<script>` block — it's the only JS in the page and it's essential because similar colors (e.g. cyan vs teal) are hard to distinguish by eye alone.

Structure:
```html
<!-- Legend -->
<div class="legend">
  <div class="legend-item" data-layer="entry"
       onmouseenter="highlight('entry')" onmouseleave="clearHighlight()">
    <span class="legend-dot" style="background:var(--accent)"></span> Entry Point
  </div>
  <!-- ...one per layer... -->
</div>

<!-- Tree -->
<div class="tree" id="tree">
  <div class="tree-line" data-layer="entry">
    <span class="left"><span class="connector">├── </span><span class="dir-entry">scripts/</span></span>
    <span class="desc">CLI entry points</span>
  </div>
  <div class="tree-line" data-layer="entry">
    <span class="left"><span class="connector">│   └── </span><span class="file">migrate_pages.py</span></span>
    <span class="desc">argparse + main</span>
  </div>
  <div class="tree-line spacer"></div>
  <!-- ...more directories... -->
</div>

<script>
const tree = document.getElementById('tree');
function highlight(layer) {
  tree.classList.add('filtering');
  document.querySelectorAll('.legend-item').forEach(li =>
    li.classList.toggle('active', li.dataset.layer === layer));
  tree.querySelectorAll('.tree-line').forEach(line =>
    line.classList.toggle('highlighted', line.dataset.layer === layer));
}
function clearHighlight() {
  tree.classList.remove('filtering');
  document.querySelectorAll('.legend-item').forEach(li => li.classList.remove('active'));
  tree.querySelectorAll('.tree-line').forEach(line => line.classList.remove('highlighted'));
}
</script>
```

Key CSS:
```css
/* Each line is a flex row — description floats right */
.tree-line {
  display: flex; align-items: baseline;
  padding: 0.15rem 1.25rem;
  font-family: 'SF Mono', 'Fira Code', monospace; font-size: 0.85rem;
  line-height: 1.8; gap: 0.5rem;
  transition: opacity 0.25s; border-left: 3px solid transparent;
}
.tree-line .left { white-space: pre; flex-shrink: 0; }
.tree-line .desc { margin-left: auto; color: var(--text-muted); font-style: italic; font-size: 0.82rem; white-space: nowrap; }
.tree-line .connector { color: #484f58; }
.tree-line .file { color: var(--text); }
.tree-line.spacer { height: 0.35rem; }

/* Directory colors — MUST match Component Architecture layer colors */
.dir-entry   { color: var(--accent); font-weight: 600; }  /* blue */
.dir-command { color: var(--orange); font-weight: 600; }  /* orange */
.dir-service { color: var(--purple); font-weight: 600; }  /* purple */
.dir-infra   { color: var(--pink);   font-weight: 600; }  /* pink */
.dir-model   { color: var(--cyan);   font-weight: 600; }  /* cyan */
.dir-config  { color: var(--teal);   font-weight: 600; }  /* teal */
.dir-input   { color: var(--green);  font-weight: 600; }  /* green */

/* Legend hover → dim non-matching, glow matching */
.tree.filtering .tree-line { opacity: 0.2; }
.tree.filtering .tree-line.highlighted { opacity: 1; background: rgba(255,255,255,0.03); }
.tree.filtering .tree-line.highlighted[data-layer="entry"]   { border-left-color: var(--accent); }
.tree.filtering .tree-line.highlighted[data-layer="command"] { border-left-color: var(--orange); }
.tree.filtering .tree-line.highlighted[data-layer="service"] { border-left-color: var(--purple); }
.tree.filtering .tree-line.highlighted[data-layer="infra"]   { border-left-color: var(--pink); }
.tree.filtering .tree-line.highlighted[data-layer="model"]   { border-left-color: var(--cyan); }
.tree.filtering .tree-line.highlighted[data-layer="config"]  { border-left-color: var(--teal); }
.tree.filtering .tree-line.highlighted[data-layer="input"]   { border-left-color: var(--green); }

/* Legend items */
.legend { display: flex; flex-wrap: wrap; gap: 0.25rem 0.75rem; margin-bottom: 1rem; font-size: 0.8rem; }
.legend-item {
  display: flex; align-items: center; gap: 0.4rem; color: var(--text-muted);
  padding: 0.3rem 0.6rem; border-radius: 6px; cursor: pointer;
  border: 1px solid transparent; transition: all 0.2s;
}
.legend-item:hover { background: rgba(255,255,255,0.05); border-color: var(--border); }
.legend-item.active { color: var(--text); border-color: var(--border); }
.legend-dot { width: 8px; height: 8px; border-radius: 50%; }
```

## Design System

Use a dark theme with CSS custom properties:

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

Layer color mapping (consistent across Component Architecture, Project Structure, and Data Flow):
- **green** = input
- **blue (accent)** = entry point
- **orange** = command / orchestrator
- **purple** = service / domain logic
- **pink** = infrastructure / external adapters
- **cyan** = models / DTOs
- **red** = external systems
- **teal** = config / output

General styling rules:
- CSS Grid for card layouts and architecture diagrams
- Responsive: collapse multi-column grids to single column on mobile
- Professional typography with clear hierarchy
- Hover effects on interactive elements (subtle background/border changes)
- No external dependencies, no CDN links

## Adaptation

The content must reflect the ACTUAL project — not a generic template. Read the code first, then design sections that make sense for what you find:

- **CLI tool**: emphasize commands, flags, input/output formats
- **Web app**: emphasize routes, components, state management, API endpoints
- **Library**: emphasize public API, module structure, usage examples
- **Microservice**: emphasize API contracts, message queues, deployment config
