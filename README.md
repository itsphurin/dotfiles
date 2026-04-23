# dotfiles

![macOS](https://img.shields.io/badge/-macOS-000?logo=apple&logoColor=white)
![Arch Linux](https://img.shields.io/badge/-Arch_Linux-1793D1?logo=archlinux&logoColor=white)
![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)

Personal development environment managed with [Dotbot](https://github.com/anishathalye/dotbot).

## Preview

![Workflow](.github/assets/workflow-screenshot.gif)

## Stack

| Category | Tool |
|----------|------|
| Shell | zsh + oh-my-zsh |
| Prompt | starship |
| Editor | neovim (Lua config) |
| Terminal | kitty |
| Multiplexer | tmux + tmux-resurrect |

## Install

```bash
git clone --recursive git@github.com:itsphurin/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install
```

## Structure

```
zsh/           # Shell config and scripts
  scripts/     # Sourced utilities (git, k8s, brew helpers)
  scripts/custom/  # Your custom scripts (auto-loaded)
config/        # XDG configs (nvim, kitty, hypr, etc.)
macos/         # Brewfile and macOS defaults
arch/          # Arch Linux setup and package lists
tmux/          # Tmux configuration
```

## Customization

Add personal shell functions to `zsh/scripts/custom/*.sh` — they load automatically.

## License

[MIT](LICENSE)
