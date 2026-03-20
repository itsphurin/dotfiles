# Setup MCP — Bootstrap `.mcp.json` for a new project

You are helping the user set up or update a `.mcp.json` file in their current project directory so that MCP servers are available when they open Claude Code in this repo.

**Context-aware execution:** Before starting the steps below, read the user's message carefully. If they already provided server names, credentials, or the action (add/replace), carry that forward — don't re-ask. If the user provided ALL required values for ALL servers in their message, skip straight to Step 4 (generate config). When a server requires multiple values (e.g., n8n needs both URL and key), always collect ALL required values even if the user only mentioned one.

**Credential precedence:** If the user explicitly provides credentials in their message, ALWAYS use those — even if you find existing configs for the same server. User-provided values override any reuse logic.

## Step 1: Check existing state

- Check if `.mcp.json` already exists in the current working directory.
  - If it exists, read it and show the user what's already configured.
    - If the user already said "add" in their message, proceed to Step 2 in add mode.
    - Otherwise ask: **add to it**, **replace it**, or **cancel**.
  - If `.mcp.json.example` exists, read it too — it may hint at the expected structure for this project.
- If no `.mcp.json` exists, proceed to Step 2.

## Step 2: Detect available MCP servers

**Two sources — use both:**

### 2a. Runtime detection
Look at the MCP tools available in the current session (tools prefixed with `mcp__`). Group them by server name — the segment between the first `mcp__` and the next `__`.

**Plugin-namespaced tools** like `mcp__plugin_playwright_playwright__*` should be displayed by their friendly name (e.g., "Playwright"), not the raw extracted segment. Strip `plugin_` prefixes and deduplicate.

### 2b. Fallback catalog
Always show this catalog alongside detected servers. Mark detected ones with **(active in session)**.

| Server | Description | Credentials needed |
|--------|-------------|-------------------|
| `github` | GitHub API — issues, PRs, repos, code search | `GITHUB_PERSONAL_ACCESS_TOKEN` |
| `n8n-mcp` | n8n workflow automation — manage workflows via API | `N8N_API_URL`, `N8N_API_KEY` |
| `supabase` | Supabase database, auth, and storage | Project URL + service role key |
| `json2doc` | Document generation from JSON templates | API key |
| `filesystem` | Read/write files outside the project directory | None — configure allowed paths |
| `sqlite` | Query SQLite databases | None — configure DB path |
| `postgres` | Query PostgreSQL databases | Connection string |
| `slack` | Slack messaging and channel management | Bot token |
| `linear` | Linear issue tracking | API key |
| `sentry` | Sentry error monitoring | Auth token + org slug |
| `brave-search` | Web search via Brave API | API key |
| `fetch` | Make HTTP requests to any URL | None |

**If the user already named specific servers**, skip the selection prompt — just confirm and move on.

Otherwise ask: **"Which MCP servers do you want?"** (allow multi-select)

Also: **"Any servers not in this list?"** If so, see the "Unknown servers" section in Step 3.

## Step 3: For each selected server — resolve config & credentials

**Batch approach:** First, silently resolve all servers that need no user input (active-in-session reuse, no-creds servers with values already provided, user-provided credentials). Then ask for ALL remaining missing information in a **single consolidated message** — don't ask one server at a time. For example: "I need a few things: (1) your n8n URL and API key, (2) your postgres connection string. Also, do you have a Slack bot token or should I skip Slack for now?"

**Fast path:** If the user already provided all required credentials for a server in their message, skip directly to building that server's config — no reuse check, no credential prompt.

### 3a. Check for existing config to reuse

Only run this step if the user did NOT provide credentials for this server.

Search these locations for existing `.mcp.json` files (NOT `.mcp.json.example` — those contain placeholders, not real credentials):
1. Sibling project directories (`../*/.mcp.json`)
2. Any `.mcp.json` files the user mentions

**If found and the server is active in the current session:** Silently reuse the config.

**If found but NOT active:** Ask: **"I found an existing config for [server]. Reuse it, or set up fresh?"**

**If not found but server IS active in session:** Ask the user: **"[Server] is active but I can't find its config. What's the full path to the project directory that has it?"** If the user provides a path but the file doesn't exist there, ask them to double-check or offer to set up fresh credentials instead.

### 3b. Container runtime (for Docker-based servers like GitHub)
Check which is available:
- `which podman` → prefer if found
- `which docker` → fallback
- Neither → warn the user: "GitHub MCP requires podman or docker. Install one (`brew install podman` or Docker Desktop), then re-run `/setup-mcp` to add GitHub." **Skip this server** and continue with the rest.

### 3c. Handle credentials

Collect all missing credentials in the batch message described above.

- **Has credentials:** User pastes values. Use them immediately.
- **Needs help:** Provide the relevant credential guide(s), then end with: **"Paste the values here when you're ready and I'll generate your `.mcp.json`."**
- **Gives up / wants to skip:** Skip that server and continue with the rest.

**If ALL selected servers end up skipped**, tell the user nothing was configured and they can re-run `/setup-mcp` when ready. Do NOT write an empty `.mcp.json`.

### 3e. Unknown servers (not in catalog)

When the user requests a server not in the catalog:

1. **Try to resolve it yourself first.** Use your knowledge or search npm (`npmjs.com`) / web for the MCP server package. Common naming patterns: `@org/mcp-server`, `mcp-server-<name>`, `<name>-mcp`. Most follow the `npx -y <package-name>` pattern with env vars for credentials.
2. **If you find it:** Show the user the package name, required env vars, and the config you'll generate. Ask them to confirm before proceeding.
3. **If you can't find it:** Ask the user: "What's the npm package name for [server]? (Check the server's GitHub or docs if you're not sure.)" If the user also doesn't know, **skip this server** — mention it in Step 6 so they can add it later.
4. **Credential handling:** Once the package is identified, determine its required env vars (from package README, npm page, or your knowledge). Then handle credentials using the same flow as Step 3c — include this server's missing values in the batch message, provide a setup guide in the same style as the credential guides below, and allow skipping if the user can't provide them.

### 3d. No credentials needed
Servers like `filesystem`, `sqlite`, `fetch` just need configuration values:
- `filesystem`: Ask which directories to allow access to
- `sqlite`: Ask for the path to the database file
- `postgres`: Ask for the connection string

## Step 4: Generate `.mcp.json`

**If all servers were skipped**, do NOT generate a file. Tell the user and stop.

Build the JSON. The format:

```json
{
  "mcpServers": {
    "<server-name>": {
      "command": "<command>",
      "args": ["<args>"],
      "env": {
        "<ENV_VAR>": "<value>"
      }
    }
  }
}
```

**Reference configs:**

```jsonc
// GitHub (container-based — use podman or docker)
"github": {
  "command": "podman",
  "args": ["run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN", "ghcr.io/github/github-mcp-server"],
  "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "<token>" }
}

// n8n
"n8n-mcp": {
  "command": "npx",
  "args": ["n8n-mcp"],
  "env": {
    "MCP_MODE": "stdio",
    "LOG_LEVEL": "error",
    "DISABLE_CONSOLE_OUTPUT": "true",
    "N8N_API_URL": "<url>",
    "N8N_API_KEY": "<key>"
  }
}

// Filesystem
"filesystem": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/dir"]
}

// SQLite
"sqlite": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-sqlite", "/path/to/db.sqlite"]
}

// PostgreSQL
"postgres": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://user:pass@host:5432/db"]
}

// Brave Search
"brave-search": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-brave-search"],
  "env": { "BRAVE_API_KEY": "<key>" }
}

// Fetch
"fetch": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-fetch"]
}

// Slack
"slack": {
  "command": "npx",
  "args": ["-y", "@anthropic/mcp-server-slack"],
  "env": { "SLACK_BOT_TOKEN": "<xoxb-token>" }
}

// Linear
"linear": {
  "command": "npx",
  "args": ["-y", "mcp-linear"],
  "env": { "LINEAR_API_KEY": "<key>" }
}

// Sentry
"sentry": {
  "command": "npx",
  "args": ["-y", "mcp-server-sentry", "--auth-token", "<token>"],
  "env": { "SENTRY_ORG": "<org-slug>" }
}
```

**When adding to an existing `.mcp.json`:** Merge new servers into the existing `mcpServers` object. Preserve existing entries exactly — don't modify or overwrite them unless the user explicitly asked.

## Step 5: Write the file

1. **Show the final `.mcp.json`** to the user before writing. Ask for confirmation.
2. **Write** to `<cwd>/.mcp.json`.
3. **Git safety — `.gitignore`:**
   - Check if `.gitignore` exists. If not, create it.
   - Check if `.mcp.json` is already covered (exact line or by a pattern). If not, append `.mcp.json` to it.
   - Don't add a duplicate entry.
4. **`.mcp.json.example`:** If it doesn't exist and this is a git repo, create it automatically (don't ask — just do it and mention in Step 6):
   - Include ALL servers the user selected (even skipped ones) — skipped servers get full placeholder configs so teammates or the user's future self can fill them in.
   - Keep non-secret env vars verbatim (e.g., `MCP_MODE`, `LOG_LEVEL`, `DISABLE_CONSOLE_OUTPUT`)
   - Replace only actual secrets with placeholders (e.g., `<your-github-pat>`, `<your-n8n-api-key>`)

## Step 6: Done

Tell the user in a single message:
- "Your `.mcp.json` is ready. **Restart Claude Code** (or run `/mcp`) to activate the new MCP servers."
- If `.mcp.json.example` was created: "Also created `.mcp.json.example` for teammates."
- If any servers were skipped: "Run `/setup-mcp` again later to add [skipped servers]."

## Rules

- **Never expose real tokens** in `.mcp.json.example` — secret values get placeholders only.
- **Never commit `.mcp.json`** — always ensure `.gitignore` coverage.
- Be concise. Skip explanations the user doesn't need.
- If the user pastes a token, use it immediately — no re-confirmation.
- When adding to existing config, preserve existing entries exactly.
- If a user can't provide credentials for a server, skip it — don't block the whole setup.
- Don't write an empty `.mcp.json` if all servers were skipped.
- User-provided credentials always override reuse/found configs.
- Only reuse from actual `.mcp.json` files, never from `.mcp.json.example`.

#### Credential guides

**GitHub**
- Needs: `GITHUB_PERSONAL_ACCESS_TOKEN`
- Steps:
  1. Go to **github.com -> Settings -> Developer settings -> Personal access tokens -> Fine-grained tokens**
  2. Click **"Generate new token"**
  3. **Resource owner:** Select your personal account (or the org you need access to)
  4. Set expiration (recommend 90 days)
  5. Under **Repository access**, select the repos you need or "All repositories"
  6. Under **Permissions**, enable at minimum:
     - **Contents** (read/write) — for file operations
     - **Issues** (read/write) — for issue management
     - **Pull requests** (read/write) — for PR workflows
     - **Metadata** (read) — required for all tokens
     - **Actions** (read) — if you use GitHub Actions
  7. Click **Generate token** and copy it (starts with `github_pat_`)

**n8n**
- Needs: `N8N_API_URL` and `N8N_API_KEY`
- Steps:
  1. Open your n8n instance in the browser
  2. Go to **Settings** (gear icon, bottom-left) -> **API**
  3. Click **"Create API Key"**, give it a name
  4. Copy the API key
  5. Your `N8N_API_URL` is the base URL of your instance (e.g., `https://n8n.example.com`)
     - **Important:** No trailing slash (use `https://n8n.example.com`, not `https://n8n.example.com/`)

**Supabase**
- Needs: `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY`
- Steps:
  1. Go to **supabase.com** -> your project
  2. **Settings -> API**
  3. Copy **Project URL** and the **service_role** key (under Project API keys)

**Linear**
- Needs: `LINEAR_API_KEY`
- Steps: **linear.app -> Settings -> API -> Personal API keys** -> Create new key

**Slack**
- Needs: `SLACK_BOT_TOKEN`
- Steps:
  1. Go to **api.slack.com/apps** -> Create or select your app
  2. **OAuth & Permissions** -> Install to Workspace
  3. Copy the **Bot User OAuth Token** (starts with `xoxb-`)

**Sentry**
- Needs: `SENTRY_AUTH_TOKEN` and `SENTRY_ORG`
- Steps:
  1. **sentry.io -> Settings -> Auth Tokens** -> Create token with `project:read`, `org:read`, `event:read`
  2. Note your org slug from the Sentry URL

**Brave Search**
- Needs: `BRAVE_API_KEY`
- Steps: **brave.com/search/api** -> Get API Key -> Sign up and create key

**json2doc**
- Needs: API key
- Steps: Check json2doc docs for API key creation
