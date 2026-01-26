#!/usr/bin/env zsh

# Go environments

# export GOROOT=/usr/local/go

if [[ $ID == "arch" ]]; then
  export GOROOT=/usr/lib/go
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Static path (regenerate with: brew --prefix golang)
  export GOROOT="/opt/homebrew/opt/go/libexec"
fi

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin
