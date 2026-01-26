#!/usr/bin/env zsh

if [[ "$OSTYPE" == "darwin"* ]]; then
  function man() {
    local theme
    if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
      theme='Monokai Extended'
    else
      theme='Monokai Extended Light'
    fi
    eval "function man() { update_man_width; BAT_THEME='$theme' batman \"\$@\"; }"
    man "$@"
  }
fi
