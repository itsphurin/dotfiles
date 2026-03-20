---
name: explain-codebase
description: Use when the user wants to understand a codebase's architecture, tech stack, or data flow - generates a professional HTML architecture page and opens it in the browser. Triggers on requests like "explain this project", "show me the architecture", "what does this codebase do".
---

# Explain Codebase

## Overview

Investigate the current project and produce a single-page HTML architecture visualization. The page should be professional, dark-themed, and cover the system architecture, tech stack, data flow, and project structure. Open the result in the user's default browser.

## Process

1. **Investigate the project:**
   - Read `pyproject.toml`, `package.json`, `Cargo.toml`, or equivalent for dependencies and project metadata
   - Glob for source files across all top-level directories (skip `.venv`, `node_modules`, `target`, etc.)
   - Read key entry points, config files, and core modules to understand the architecture
   - Check for existing docs (`README.md`, `CLAUDE.md`, `AGENTS.md`) for additional context
   - Identify: tech stack, module boundaries, data flow, external integrations

2. **Create `architecture.html` in the project root** with these sections:
   - **Tech Stack** — card grid of key dependencies with their roles
   - **Component Architecture** — layered diagram showing how modules connect (inputs, entry points, services, utilities, external systems, outputs)
   - **Data Flow** — step-by-step pipeline showing how data moves through the system
   - **Key abstractions** — tables or diagrams for domain-specific concepts (metrics, API mappings, etc.) as appropriate
   - **Project Structure** — annotated file tree with descriptions

3. **Open in browser:** `open architecture.html` (macOS) or equivalent

## Design Guidelines

- Clean, minimal CSS — no external dependencies or CDN links
- Responsive layout with CSS grid
- Color-coded elements by role (inputs, services, utilities, outputs, external)
- Monospace font for file trees and code references
- Professional typography with clear hierarchy

## Adaptation

The content must reflect the ACTUAL project — not a template. Read the code first, then design sections that make sense for what you find. A React app needs different sections than a Python CLI tool or a Rust library.
