#!/usr/bin/env bash

# Ordered cheapest test first: $OSTYPE and $ID are shell variables, but the WSL
# check forks `uname` (~10ms on this machine), so it has to stay last.
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias gopen='git config --get remote.origin.url | perl -pe "s/:(?!\/\/)/\//g" | sed "s/.*git@/https:\/\//" | sed "s/.git$//" | xargs -I % echo "open %" | sh'
  alias gopr='
    git config --get remote.origin.url | \
    perl -pe "s/:(?!\/\/)/\//g" | \
    sed "s/.*git@/https:\/\//" | \
    sed "s/.git$//" | \
    xargs -I _ echo "open _/pull-requests/new?source=$(git branch --show-current)\&dest=develop" | sh'
elif [[ $ID == "arch" ]]; then
  alias gopen='git config --get remote.origin.url | perl -pe "s/:(?!\/\/)/\//g" | sed "s/.*git@/https:\/\//" | sed "s/.git$//" | xargs -I % echo "xdg-open %" | sh'
  alias gopr='
    git config --get remote.origin.url | \
    perl -pe "s/:(?!\/\/)/\//g" | sed "s/.*git@/https:\/\//" | \
    sed "s/.git$//" | \
    xargs -I _ echo "xdg-open _/pull-requests/new?source=$(git branch --show-current)\&dest=develop" | sh'
elif [[ $(uname -r) == *'WSL'* ]]; then
  alias gopen='git config --get remote.origin.url | perl -pe "s/:(?!\/\/)/\//g" | sed "s/.*git@/https:\/\//" | sed "s/.git$//" | xargs -I % echo "explorer.exe %" | sh'
  alias gopr='
    git config --get remote.origin.url | \
    perl -pe "s/:(?!\/\/)/\//g" | sed "s/.*git@/https:\/\//" | \
    sed "s/.git$//" | \
    xargs -I _ echo "explorer.exe _/pull-requests/new?source=$(git branch --show-current)\&dest=develop" | sh'
fi
