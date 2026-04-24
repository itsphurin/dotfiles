#!/bin/sh

input=$(cat)
# DEBUG: capture the stdin payload so we can inspect its shape
printf '%s' "$input" > /tmp/claude-statusline-input.json

# ---------------------------------------------------------------------------
# ANSI color helpers
# ---------------------------------------------------------------------------

# Reset
R='\033[0m'
# Styles
BOLD='\033[1m'
DIM='\033[2m'
# Foreground colors
FG_WHITE='\033[97m'
FG_CYAN='\033[36m'
FG_YELLOW='\033[33m'
FG_MAGENTA='\033[35m'
FG_BLUE='\033[34m'
FG_GREEN='\033[32m'
FG_RED='\033[31m'
FG_DARK_GRAY='\033[90m'

# Convenience combos
C_DIM="${DIM}"
C_LABEL="${DIM}"
C_SEP="${DIM}${FG_DARK_GRAY}"
C_REPO="${BOLD}${FG_WHITE}"
C_BRANCH="${BOLD}${FG_CYAN}"
C_UNCOMMITTED="${BOLD}${FG_YELLOW}"
C_MODEL="${BOLD}${FG_MAGENTA}"
C_MODE="${BOLD}${FG_BLUE}"
C_BAR_FILL="${FG_GREEN}"
C_BAR_EMPTY="${FG_DARK_GRAY}"
C_BAR_PCT="${FG_YELLOW}"
C_BAR_ETA="${DIM}"
C_SESSION_VAL="${FG_WHITE}"
C_TOK="${DIM}${FG_WHITE}"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

SEP="${C_SEP} | ${R}"

# Render a colored 8-char bar: make_bar_colored <percent_0_to_100> [fill_color]
# fill_color defaults to C_BAR_FILL (green)
make_bar_colored() {
  pct="${1:-0}"
  fill_color="${2:-${C_BAR_FILL}}"
  filled=$(echo "$pct" | awk '{v=int($1*8/100+0.5); if(v>8)v=8; print v}')
  i=0
  bar=""
  while [ "$i" -lt "$filled" ]; do
    bar="${bar}${fill_color}#${R}"
    i=$((i+1))
  done
  while [ "$i" -lt 8 ]; do
    bar="${bar}${C_BAR_EMPTY}-${R}"
    i=$((i+1))
  done
  printf "%b" "$bar"
}

# Plain (no color) bar — kept for any internal pct math
make_bar() {
  pct="${1:-0}"
  filled=$(echo "$pct" | awk '{v=int($1*8/100+0.5); if(v>8)v=8; print v}')
  bar=""
  i=0
  while [ "$i" -lt "$filled" ]; do bar="${bar}#"; i=$((i+1)); done
  while [ "$i" -lt 8 ];         do bar="${bar}-"; i=$((i+1)); done
  printf "%s" "$bar"
}

# Format seconds into "Xh Ym" or "Ym" or "Xs"
fmt_duration() {
  secs="${1:-0}"
  secs=$(printf '%.0f' "$secs")
  if [ "$secs" -ge 3600 ]; then
    h=$((secs/3600))
    m=$(( (secs%3600)/60 ))
    printf "%dh%dm" "$h" "$m"
  elif [ "$secs" -ge 60 ]; then
    printf "%dm" "$((secs/60))"
  else
    printf "%ds" "$secs"
  fi
}

# ---------------------------------------------------------------------------
# Extract JSON fields
# ---------------------------------------------------------------------------

cwd=$(echo "$input"          | jq -r '.workspace.current_dir // .cwd // ""')
transcript=$(echo "$input"   | jq -r '.transcript_path // ""')
model_id=$(echo "$input"     | jq -r '.model.id // ""')
model_name=$(echo "$input"   | jq -r '.model.display_name // "Claude"')
version=$(echo "$input"      | jq -r '.version // ""')
thinking_enabled=$(echo "$input" | jq -r '.thinking.enabled // false')
vim_mode=$(echo "$input"     | jq -r '.vim.mode // ""')

ctx_used=$(echo "$input"     | jq -r '.context_window.used_percentage // empty')
ctx_total=$(echo "$input"    | jq -r '.context_window.context_window_size // 0')

in_tok=$(echo "$input"       | jq -r '.context_window.current_usage.input_tokens // 0')
out_tok=$(echo "$input"      | jq -r '.context_window.current_usage.output_tokens // 0')
cost_usd=$(echo "$input"     | jq -r '.cost.total_cost_usd // empty')
total_in_tok=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out_tok=$(echo "$input"| jq -r '.context_window.total_output_tokens // 0')

rl_5h_pct=$(echo "$input"    | jq -r '.rate_limits.five_hour.used_percentage // empty')
rl_5h_rst=$(echo "$input"    | jq -r '.rate_limits.five_hour.resets_at // empty')
rl_7d_pct=$(echo "$input"    | jq -r '.rate_limits.seven_day.used_percentage // empty')
rl_7d_rst=$(echo "$input"    | jq -r '.rate_limits.seven_day.resets_at // empty')
rl_sn_pct=$(echo "$input"    | jq -r '.rate_limits.seven_day_sonnet.used_percentage // empty')
rl_sn_rst=$(echo "$input"    | jq -r '.rate_limits.seven_day_sonnet.resets_at // empty')

# ---------------------------------------------------------------------------
# Model label for line 2 prefix
# ---------------------------------------------------------------------------

# Build a short form: strip "claude-" prefix and use the remainder, e.g. "sonnet-4-6"
model_label_inner=$(echo "$model_id" | sed 's/^claude-//')
# Fall back to display name lowercased if model_id is empty
if [ -z "$model_label_inner" ]; then
  model_label_inner=$(echo "$model_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
fi
omc_label="[${model_label_inner}]"

# ---------------------------------------------------------------------------
# Git info (repo name, branch, uncommitted file count)
# ---------------------------------------------------------------------------

repo=""
branch=""
uncommitted=0
if [ -n "$cwd" ]; then
  git_root=$(git -C "$cwd" --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
  if [ -n "$git_root" ]; then
    repo=$(basename "$git_root")
    branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
    uncommitted=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  fi
fi

# ---------------------------------------------------------------------------
# Session duration from transcript file mtime (creation proxy)
# ---------------------------------------------------------------------------

session_dur=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  file_mtime=$(stat -f "%B" "$transcript" 2>/dev/null || stat -c "%W" "$transcript" 2>/dev/null)
  if [ -z "$file_mtime" ] || [ "$file_mtime" = "0" ]; then
    # Fall back to modification time
    file_mtime=$(stat -f "%m" "$transcript" 2>/dev/null || stat -c "%Y" "$transcript" 2>/dev/null)
  fi
  if [ -n "$file_mtime" ] && [ "$file_mtime" != "0" ]; then
    now=$(date +%s)
    elapsed=$((now - file_mtime))
    session_dur=$(fmt_duration "$elapsed")
  fi
fi

# ---------------------------------------------------------------------------
# Rate limit bars with time-to-reset
# ---------------------------------------------------------------------------

now_epoch=$(date +%s)

# Empty bar: 8 dark-gray dashes
empty_bar="${C_BAR_EMPTY}--------${R}"

if [ -n "$rl_5h_pct" ]; then
  bar=$(make_bar_colored "$rl_5h_pct")
  pct_int=$(printf '%.0f' "$rl_5h_pct")
  eta="${C_BAR_ETA}(~--)${R}"
  if [ -n "$rl_5h_rst" ]; then
    remaining_secs=$((rl_5h_rst - now_epoch))
    if [ "$remaining_secs" -gt 0 ]; then
      eta="${C_BAR_ETA}(~$(fmt_duration "$remaining_secs"))${R}"
    fi
  fi
  rl_5h_seg="⏱ ${C_LABEL}5h:${R}[${bar}]${C_BAR_PCT}${pct_int}%${R}${eta}"
else
  rl_5h_seg="⏱ ${C_LABEL}5h:${R}[${empty_bar}]${C_BAR_ETA}--%${R}${C_BAR_ETA}(~--)${R}"
fi

if [ -n "$rl_7d_pct" ]; then
  bar=$(make_bar_colored "$rl_7d_pct")
  pct_int=$(printf '%.0f' "$rl_7d_pct")
  eta="${C_BAR_ETA}(~--)${R}"
  if [ -n "$rl_7d_rst" ]; then
    remaining_secs=$((rl_7d_rst - now_epoch))
    if [ "$remaining_secs" -gt 0 ]; then
      eta="${C_BAR_ETA}(~$(fmt_duration "$remaining_secs"))${R}"
    fi
  fi
  rl_7d_seg="📅 ${C_LABEL}wk:${R}[${bar}]${C_BAR_PCT}${pct_int}%${R}${eta}"
else
  rl_7d_seg="📅 ${C_LABEL}wk:${R}[${empty_bar}]${C_BAR_ETA}--%${R}${C_BAR_ETA}(~--)${R}"
fi

# ---------------------------------------------------------------------------
# Session total token counts
# ---------------------------------------------------------------------------

fmt_si() {
  awk -v n="$1" 'BEGIN {
    if (n >= 1000000) printf "%.1fM", n/1000000
    else if (n >= 1000) printf "%.1fk", n/1000
    else printf "%d", n
  }'
}

if [ "$total_in_tok" != "0" ] || [ "$total_out_tok" != "0" ]; then
  total_in_fmt=$(fmt_si "$total_in_tok")
  total_out_fmt=$(fmt_si "$total_out_tok")
  total_tok_seg="${C_LABEL}token:${R} 📥 ${FG_WHITE}in:${R}${FG_CYAN}${total_in_fmt}${R} 📤 ${FG_WHITE}out:${R}${FG_GREEN}${total_out_fmt}${R}"
else
  total_tok_seg="${C_LABEL}token:${R} 📥 ${FG_WHITE}in:${R}${C_BAR_ETA}--${R} 📤 ${FG_WHITE}out:${R}${C_BAR_ETA}--${R}"
fi

# ---------------------------------------------------------------------------
# Context bar (color based on usage level)
# ---------------------------------------------------------------------------

if [ -n "$ctx_used" ]; then
  pct_int=$(printf '%.0f' "$ctx_used")
  # Pick fill color based on usage: <50 green, 50-80 yellow, >80 red
  if [ "$pct_int" -ge 80 ]; then
    ctx_fill="${FG_RED}"
    ctx_pct_color="${FG_RED}"
  elif [ "$pct_int" -ge 50 ]; then
    ctx_fill="${FG_YELLOW}"
    ctx_pct_color="${FG_YELLOW}"
  else
    ctx_fill="${FG_GREEN}"
    ctx_pct_color="${FG_GREEN}"
  fi
  bar=$(make_bar_colored "$ctx_used" "$ctx_fill")
  ctx_seg="📊 ${C_LABEL}ctx:${R}[${bar}]${ctx_pct_color}${pct_int}%${R}"
else
  ctx_seg="📊 ${C_LABEL}ctx:${R}[${empty_bar}]${C_BAR_ETA}--%${R}"
fi

# ---------------------------------------------------------------------------
# Thinking effort — parse transcript JSONL for the most recent assistant turn
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Effort level from settings.json
# ---------------------------------------------------------------------------

effort_level=$(jq -r '.effortLevel // empty' "$HOME/.claude/settings.json" 2>/dev/null)

case "$effort_level" in
  low)    effort_pct=25;  effort_fill="${FG_GREEN}";  effort_pct_color="${FG_GREEN}"  ;;
  medium) effort_pct=50;  effort_fill="${FG_GREEN}";  effort_pct_color="${FG_GREEN}"  ;;
  high)   effort_pct=75;  effort_fill="${FG_YELLOW}"; effort_pct_color="${FG_YELLOW}" ;;
  xhigh)  effort_pct=87;  effort_fill="${FG_RED}";    effort_pct_color="${FG_RED}"    ;;
  max)    effort_pct=100; effort_fill="${FG_RED}";    effort_pct_color="${FG_RED}"    ;;
  *)      effort_pct=""   ;;
esac

if [ -n "$effort_pct" ]; then
  effort_bar=$(make_bar_colored "$effort_pct" "$effort_fill")
  effort_seg="🧩 ${C_LABEL}effort:${R}[${effort_bar}]${effort_pct_color}${effort_level}${R}"
else
  effort_seg="🧩 ${C_LABEL}effort:${R}[${empty_bar}]${C_BAR_ETA}--${R}"
fi

# ---------------------------------------------------------------------------
# Token counts  \<input>k $<output>k  (using \ and $ as in the HUD)
# ---------------------------------------------------------------------------

if [ -n "$cost_usd" ]; then
  cost_fmt=$(printf '$%.2f' "$cost_usd")
  cost_seg="💰 ${C_SESSION_VAL}${cost_fmt}${R}"
else
  cost_seg="💰 ${C_BAR_ETA}\$--${R}"
fi

# ---------------------------------------------------------------------------
# Assemble LINE 1
# ---------------------------------------------------------------------------

# Repo / branch — always shown; use placeholders when no git repo
if [ -n "$repo" ]; then
  repo_display="${C_REPO}${repo}${R}"
  if [ -n "$branch" ]; then
    branch_display="${C_BRANCH}${branch}${R}"
  else
    branch_display="${C_BAR_ETA}--${R}"
  fi
else
  repo_display="${C_BAR_ETA}--${R}"
  branch_display="${C_BAR_ETA}--${R}"
fi

line1="📁 ${C_LABEL}repo:${R}${repo_display}${SEP}🌿 ${C_LABEL}branch:${R}${branch_display}${SEP}${C_UNCOMMITTED}?${uncommitted}${R}"

# ---------------------------------------------------------------------------
# Assemble LINE 2
# ---------------------------------------------------------------------------

line2="🤖 ${C_MODEL}${omc_label}${R}"

# Rate limit segments — always shown
line2="${line2}${SEP}${rl_5h_seg} ${rl_7d_seg}"

# Context bar — always shown
line2="${line2}${SEP}${ctx_seg}"

# ---------------------------------------------------------------------------
# Assemble LINE 3 — effort + session usage
# ---------------------------------------------------------------------------

line3="${effort_seg}"

# Cost — session cumulative
line3="${line3}${SEP}${cost_seg}"

# Session total tokens
line3="${line3}${SEP}${total_tok_seg}"

# Session duration
if [ -n "$session_dur" ]; then
  line3="${line3}${SEP}🕐 ${C_LABEL}session:${R}${C_SESSION_VAL}${session_dur}${R}"
else
  line3="${line3}${SEP}🕐 ${C_LABEL}session:${R}${C_BAR_ETA}--${R}"
fi

# Thinking status
if [ "$thinking_enabled" = "true" ]; then
  line3="${line3}${SEP}🧠 ${C_LABEL}thinking:${R}${FG_GREEN}on${R}"
else
  line3="${line3}${SEP}🧠 ${C_LABEL}thinking:${R}${C_BAR_ETA}off${R}"
fi

# Claude Code version
if [ -n "$version" ]; then
  line3="${line3}${SEP}📦 ${C_LABEL}v:${R}${C_SESSION_VAL}${version}${R}"
else
  line3="${line3}${SEP}📦 ${C_LABEL}v:${R}${C_BAR_ETA}--${R}"
fi

# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------

printf "%b\n%b\n%b" "$line1" "$line2" "$line3"
