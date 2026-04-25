#!/usr/bin/env zsh

echo "\n<<< Starting Bun Setup >>>\n"

if command -v bun >/dev/null 2>&1; then
  echo "bun $(bun --version) already installed"
else
  echo "installing bun..."
  curl -fsSL https://bun.sh/install | bash
fi
