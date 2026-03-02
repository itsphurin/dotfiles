#!/bin/bash

source ~/dotfiles/.claude/hooks/.env.local

read -r input
message=$(echo "$input" | jq -r '.message // "Claude Code"')

if [[ -n "$PUSHOVER_TOKEN" && -n "$PUSHOVER_USER" ]]; then
	curl -s \
		--form-string "token=$PUSHOVER_TOKEN" \
		--form-string "user=$PUSHOVER_USER" \
		--form-string "message=$message from CLI" \
		https://api.pushover.net/1/messages.json
fi

# Only wrap for tmux - let Claude Code handle non-tmux natively
[ -z "$TMUX" ] && exit 0

# Must output to /dev/tty - hook stdout is captured by Claude Code
printf '\033Ptmux;\033\033]9;%s\007\033\\' "$message" >/dev/tty
