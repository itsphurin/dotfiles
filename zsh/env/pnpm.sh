#!/usr/bin/env zsh

# pnpm
if [[ $ID == "arch" ]]; then
	export PNPM_HOME="$(realpath ~)/.local/share/pnpm"
	case ":$PATH:" in
	*":$PNPM_HOME:"*) ;;
	*) export PATH="$PNPM_HOME:$PATH" ;;
	esac
elif [[ $OSTYPE == "darwin"* ]]; then
	export PNPM_HOME="$(realpath ~)/Library/pnpm"
	case ":$PATH:" in
	*":$PNPM_HOME:"*) ;;
	*) export PATH="$PNPM_HOME:$PATH" ;;
	esac
fi
# pnpm end
