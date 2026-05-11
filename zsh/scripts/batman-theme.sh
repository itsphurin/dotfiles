#!/usr/bin/env zsh

if [[ "$OSTYPE" == "darwin"* ]]; then
  function man() {
    local theme
    # theme='Monokai Extended'
    eval "function man() { update_man_width; BAT_THEME='$theme' batman \"\$@\"; }"
    man "$@"
  }
fi
