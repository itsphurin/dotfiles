#!/usr/bin/env zsh

# default location
export KUBECONFIG="$HOME/.kube/config"

# create switcher function
kubeconfig() {
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then
		echo "Usage: kubeconfig [path to .kube/config file]"
		echo "       Leave blank to see current \$KUBECONFIG"
	elif [[ -z "$1" ]]; then
		echo "Current \$KUBECONFIG: $KUBECONFIG"
	elif [[ -f "$1" ]]; then
		export KUBECONFIG="$1"
		echo "Switched to kubeconfig: $KUBECONFIG"
	else
		echo "Error: File not found — $1"
	fi
}

# shorten aliases
alias kconfig=kubeconfig
alias kc=kubeconfig
