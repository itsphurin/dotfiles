---
name: api-doc-site
description: Generate a browsable single-file static HTML API reference — a sidebar of grouped endpoints, scroll-spy, method badges, and clean styling — from a codebase. Two phases: derive an accurate endpoint reference (paths, methods, params, request/response shapes, auth, errors) as Markdown, then render that Markdown to a self-contained HTML page (no server, no CDN, no build step). Use when the user asks to write/craft/generate API docs, document an API or backend, produce an API reference, or turn a Markdown doc into a static HTML doc-site with a sidebar and navigation.
---

# API doc site

Produce a browsable, self-contained **`API.html`** from a codebase in two phases:

1. **Derive** an accurate API reference as Markdown (`API.md`).
2. **Render** it to a single static HTML page with a sidebar + scroll-spy.

Language-agnostic: "routers/handlers", "serializers", and "generated schema" map to whatever the
stack uses (FastAPI, Express, Rails, Spring, …).

## Phase 1 — Derive the reference (Markdown)

Build `API.md` by reading the code, not by guessing.

- [ ] **List the whole surface.** Find where routes are registered; enumerate every path + method.
      Cross-check against any generated schema (`openapi.json`, framework introspection) — it is
      authoritative for the **request** side: params, query aliases, validation bounds, enums,
      deprecated flags, request-body schemas.
- [ ] **Derive response shapes from the builder code** (serializers / DTO mappers), not from type
      hints. Handlers that return untyped dicts/maps leave generated schemas empty — response bodies
      must be traced by hand.
- [ ] **Capture cross-cutting contracts once:** base URL, content types, list/paged envelopes, field
      casing (+ exceptions), the full auth model (every mode), the error model (e.g. RFC7807) with a
      table of status codes / error slugs, and shared enums.
- [ ] **Group** endpoints (active vs deprecated/legacy); mark deprecated ones.
- [ ] **Per endpoint:** method, path, auth requirement, path/query params (aliases + bounds), request
      body, a JSON **response example**, and per-endpoint error/status notes.
- [ ] **Verify:** every route present; every response field traceable to code (no invented fields).

Field-level traps that bite: see [REFERENCE.md](REFERENCE.md) → *Accuracy traps* (string-encoded
numbers, casing exceptions, feature-gated 503s, opaque IDs, optimistic-concurrency params).

## Phase 2 — Render to static HTML

One self-contained `API.html`: inline CSS + JS, **no CDN/network, no server**. Sidebar (grouped,
method badges, scroll-spy) + readable content.

Use a **one-time converter** (Markdown → HTML) — don't hand-write HTML for a large doc. Full recipe
plus paste-in CSS and scroll-spy JS in [REFERENCE.md](REFERENCE.md) → *Converter* and *Styling assets*.

1. Parse the Markdown with **tables + fenced-code + toc** extensions. If no parser is installed, run
   it ephemerally without adding a project dependency, e.g. `uv run --with markdown python …`.
2. Build the sidebar from the heading/TOC tree; add method badges by regexing `GET|POST|PATCH|…` +
   path out of endpoint headings; wrap every table in an `overflow-x:auto` div.
3. Inline the CSS and scroll-spy JS assets from REFERENCE.md.
4. Keep the converter in a scratch/temp dir. The deliverable is the HTML — leave nothing extra in the
   repo unless asked (if they want the script kept, the source Markdown must stay too, or the HTML
   can't be regenerated).

**Validate the output:**

- [ ] every endpoint appears as **both** a heading and a sidebar link (counts match exactly)
- [ ] no parser artifacts (stray placeholders, unconverted `**` or backticks)
- [ ] tables wrapped; **no** external resource refs (grep for `http`, `cdn`, `<link`, `<script src`)
- [ ] render it (open or screenshot) to confirm it looks right

If verifying interactively with headless Chrome, read [REFERENCE.md](REFERENCE.md) → *Headless
verification* first — several non-obvious flags are required or it silently fails.
