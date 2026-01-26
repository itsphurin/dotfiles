#!/usr/bin/env bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  export BREWFILE_PATH="$HOME/dotfiles/macos/Brewfile"
  mkdir -p "$(dirname "$BREWFILE_PATH")"
  # Static brew shellenv (regenerate with: /opt/homebrew/bin/brew shellenv)
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  fpath[1,0]="/opt/homebrew/share/zsh/site-functions"
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
  [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}"
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
elif [[ $(uname -r) == *'WSL'* ]]; then
  export BREWFILE_PATH="$HOME/dotfiles/linux/WSL/Brewfile"
  mkdir -p "$(dirname "$BREWFILE_PATH")"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export BREWFILE_PATH="$HOME/dotfiles/linux/$ID/Brewfile"
  mkdir -p "$(dirname "$BREWFILE_PATH")"
  # TODO: eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

function bbd() {
  if [[ ("$OSTYPE" != "darwin"* && "$OSTYPE" != "linux-gnu"*) ]]; then
    echo "Unknown \$OSTYPE, aborting process"
  else
    brew bundle dump --force --describe --file "$BREWFILE_PATH"
    zsh -c "echo \"\" >> $BREWFILE_PATH && echo -e \"# vim:ft=ruby\" >> $BREWFILE_PATH"
  fi
}
