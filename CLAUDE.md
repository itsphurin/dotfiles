# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with [Dotbot](https://github.com/anishathalye/dotbot). Supports macOS and Arch Linux.

## Installation

```bash
git clone --recursive git@github.com:itsphurin/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install
```

The `./install` script runs Dotbot which:
1. Creates symlinks from home directory to this repo (defined in `install.conf.yaml`)
2. Runs setup scripts for each component (zsh, oh-my-zsh, starship, tmux, node, etc.)

## Key Components

| Component | Config Location | Setup Script |
|-----------|----------------|--------------|
| Zsh | `zsh/zshrc`, `zsh/zshenv` | `zsh/setup.sh` |
| Oh-my-zsh | `omz/` | `omz/setup.zsh` |
| Starship prompt | `config/starship.toml` | `starship/setup.zsh` |
| Neovim | `config/nvim/` (git submodule) | - |
| Tmux | `tmux/tmux.conf` | `tmux/setup_tpm.zsh` |
| Kitty | `config/kitty/` | - |
| macOS packages | `macos/Brewfile` | `macos/setup.zsh` |
| Arch Linux | `arch/` | `arch/builds/setup.zsh` |

## Architecture

- **Symlink-based**: Changes to files here are immediately reflected in the system
- **Platform-aware**: Setup scripts check `/etc/os-release` to run platform-specific code
- **Git submodules**: Dotbot framework (`dotbot/`) and Neovim config (`config/nvim/`) are submodules

## Zsh Scripts

Scripts in `zsh/scripts/` are sourced by zshrc:
- `git.sh` - Git helpers (`gopen`, `gopr`)
- `brew.sh` - Homebrew management
- `k8s.sh` - Kubernetes utilities
- `jira.sh` - Jira integration

**Custom scripts**: Add personal `.sh` files to `zsh/scripts/custom/` - they auto-load.

## Common Aliases

- `cdd` - cd to dotfiles
- `nvd` - open dotfiles in neovim
- `nvz` - edit zshrc
- `szsh` / `rl` - reload zsh config
- `lg` - lazygit
- `pn` - pnpm
- `mux` - tmux