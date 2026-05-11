---
name: setup-chrome-mcp
description: Set up the chrome-devtools MCP server for Claude Code CLI or Claude Desktop — auto-detects environment and installs with --autoConnect and --experimental-page-id-routing for full browser automation. Use this skill whenever the user wants to install or configure chrome-devtools MCP, set up browser automation for Claude, connect Claude to Chrome, enable take_screenshot/click/navigate/fill tools, set up MCP for myte-expense or similar browser skills, or asks "how do I set up chrome-devtools" / "setup chrome mcp" / "install chrome devtools mcp". Also trigger when another skill fails because chrome-devtools tools are missing.
---

## What this installs

`chrome-devtools-mcp` with three key flags:
- `--autoConnect` — attaches to your **already-running Chrome** (keeps your tabs and logins; no separate browser spawned)
- `--experimental-page-id-routing` — enables parallel multi-tab automation (sub-agents can each target a specific tab via `pageId`)
- `--no-usage-statistics` — disables telemetry

> Chrome must be running before you start Claude if using `--autoConnect`.

> Do **not** add `--slim` — it strips `upload_file`, which browser automation skills need.

---

## Step 1 — Detect environment

```bash
python3 -c "
import os
if os.environ.get('CLAUDE_CODE_IS_COWORK') == '1' or os.environ.get('CLAUDE_CODE_ENTRYPOINT') == 'local-agent':
    print('desktop')
elif os.environ.get('CLAUDECODE') == '1':
    execpath = os.environ.get('CLAUDE_CODE_EXECPATH', '')
    if '/Library/Application Support/Claude/claude-code/' in execpath:
        print('desktop')
    elif os.environ.get('CLAUDE_CODE_ENTRYPOINT') == 'cli':
        print('cli')
    else:
        print('unknown')
else:
    print('unknown')
"
```

| Result | Follow |
|--------|--------|
| `cli` | § CLI install |
| `desktop` | § Desktop install |
| `unknown` | Tell user to run from inside Claude Code, then stop |

---

## Step 2 — Install

### CLI install

```bash
claude mcp add chrome-devtools -- npx chrome-devtools-mcp@latest --autoConnect --experimental-page-id-routing --no-usage-statistics
```

Then verify:

```bash
claude mcp list
```

`chrome-devtools` must appear in the list. No restart needed — the MCP is available in the current session.

### Desktop install (Claude Desktop / Cowork / Code GUI)

Merge the entry into `claude_desktop_config.json` without touching other MCP servers:

```bash
python3 << 'EOF'
import json, pathlib, sys
config_path = pathlib.Path.home() / "Library/Application Support/Claude/claude_desktop_config.json"
try:
    config = json.loads(config_path.read_text()) if config_path.exists() else {}
except json.JSONDecodeError as e:
    print(f"ERROR: {config_path} is not valid JSON — fix it manually before re-running.\n  {e}", file=sys.stderr)
    sys.exit(1)
config.setdefault("mcpServers", {})
config["mcpServers"]["chrome-devtools"] = {
    "command": "npx",
    "args": ["chrome-devtools-mcp@latest", "--autoConnect", "--experimental-page-id-routing", "--no-usage-statistics"]
}
config_path.parent.mkdir(parents=True, exist_ok=True)
config_path.write_text(json.dumps(config, indent=2))
print(f"Written: {config_path}")
EOF
```

Then tell the user: **Fully quit and restart Claude Desktop (⌘Q) — closing the window is not enough.**

---

## Step 3 — Verify

**CLI:** `claude mcp list` shows `chrome-devtools` — done.

**Desktop:** After restart, ask the user to type a quick test in the new session:

```
use the chrome-devtools take_screenshot tool to screenshot the current page
```

If `take_screenshot` resolves → setup complete. If it fails → check `claude_desktop_config.json` for JSON syntax errors.

---

## Troubleshooting

**"Browser already running" / profile lock** (only if `--autoConnect` was removed from your config):

```bash
# Kill orphaned MCP processes
pkill -f 'chrome-devtools-mcp'

# Remove stale lock file (Linux only)
rm -f ~/.cache/chrome-devtools-mcp/chrome-profile/SingletonLock
```

Wait ~2 seconds and retry. On macOS, `pkill` alone is usually enough.

**CLI: already have chrome-devtools configured** — the `claude mcp add` command will fail. Run `claude mcp remove chrome-devtools` first, then re-add.

**Desktop: using both CLI and Desktop** — configure both; they don't share config.
