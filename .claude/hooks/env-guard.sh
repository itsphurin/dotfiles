#!/usr/bin/env bash
set -euo pipefail

# Read hook input from stdin
INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Extract the relevant string to check based on tool type
case "$TOOL_NAME" in
  Read)
    TARGET=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
    ;;
  Bash)
    TARGET=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
    ;;
  Grep)
    TARGET=$(echo "$INPUT" | jq -r '.tool_input.path // empty')
    ;;
  *)
    exit 0
    ;;
esac

# Only guard .env and .env.local (not .env.staging, .env.prod, .env.example, etc.)
ENV_MATCH=0
echo "$TARGET" | grep -qE '(^|/|[[:space:]"'"'"'])\.env([[:space:]"'"'"'/]|$)' && ENV_MATCH=1
echo "$TARGET" | grep -qE '(^|/|[[:space:]"'"'"'])\.env\.local([[:space:]"'"'"'/]|$)' && ENV_MATCH=1

if [ "$ENV_MATCH" -eq 0 ]; then
  exit 0
fi

# Show native macOS dialog to ask user
RESULT=$(osascript -e "
  set theResult to display dialog \"⚠️ .env file access detected!\" & return & return & \"Tool: $TOOL_NAME\" & return & \"Target: $TARGET\" & return & return & \"Allow reading this file?\" buttons {\"No\", \"Yes\"} default button \"No\" with icon caution with title \"Claude Code — env-guard\"
  return button returned of theResult
" 2>/dev/null || echo "No")

if [ "$RESULT" = "Yes" ]; then
  exit 0
else
  echo '{"continue": false, "stopReason": "User declined to read .env file"}'
  exit 0
fi
