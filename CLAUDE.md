# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with [Dotbot](https://github.com/anishathalye/dotbot). Supports macOS and Arch Linux.

## Installation

```bash
git clone --recursive git@github.com:itsphurin/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install
```

`./install` runs Dotbot, which creates symlinks and runs setup scripts defined in `install.conf.yaml`.

## Key Architecture

- **Symlink-based**: edits here are immediately live — no copy step needed
- **`install.conf.yaml`**: single source of truth for all symlinks and which setup scripts run
- **Setup scripts**: one per component (`*/setup.zsh`), idempotent, safe to re-run individually
- **Platform detection**: scripts use `$OSTYPE` or `/etc/os-release` to branch macOS vs Arch

## Components

| Component | Config | Setup script |
|-----------|--------|--------------|
| Zsh | `zsh/zshrc`, `zsh/zshenv` | `zsh/setup.sh` |
| Oh-my-zsh | `omz/` | `omz/setup.zsh` |
| Starship | `config/starship.toml` | `starship/setup.zsh` |
| Tmux | `tmux/tmux.conf` | `tmux/setup_tpm.zsh` |
| Neovim | `config/nvim/` (submodule) | — |
| Kitty | `config/kitty/` | — |
| macOS packages | `macos/Brewfile` | `macos/setup.zsh` |
| Bun | — | `bun/setup.zsh` |
| Arch Linux | `arch/` | `arch/builds/setup.zsh` |

## Claude Code Config

`.claude/` is symlinked into `~/.claude/` — settings, hooks, skills, agents, and commands all live here and are version-controlled.

- `settings.json` — main Claude Code settings (model, permissions, hooks, plugins)
- `hooks/` — shell hooks (e.g. `env-guard.sh`, `tmux-notify.sh`)
- `skills/`, `agents/`, `commands/` — custom Claude Code extensions
- `statusline-command.sh` — custom status line script

## Codex CLI Config

`.codex/config.toml` is symlinked into `~/.codex/config.toml` and stores stable Codex TUI settings, including `/statusline`. Do not symlink the whole `~/.codex/` directory because it contains auth, sessions, logs, caches, and local state.

## Zsh Scripts

`zsh/scripts/` scripts are sourced by `zshrc`. Add personal scripts to `zsh/scripts/custom/*.sh` — they auto-load.

`zsh/env/` holds runtime environment setup (Go, pnpm, Ruby gems, Claude).
