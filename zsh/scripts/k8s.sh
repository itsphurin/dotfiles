#!/usr/bin/env zsh

# create merge function
kubeconfig-merge() {
	# Dynamically get all config files in ~/.kube
	local configs=()
	for config in "$HOME/.kube"/*; do
		if [[ $config =~ '(cache|merged-config)' ]]; then
			continue
		else
			configs+="$config"
		fi

	done

	# Dynamically join configs with ':'
	export KUBECONFIG=$(
		IFS=:
		echo "${configs[*]}"
	)
	if [[ $1 =~ '-v' ]]; then; echo "KUBECONFIG=$KUBECONFIG"; fi

	# Merge and flatten to a single clean config
	kubectl config view --merge --flatten >"$HOME/.kube/merged-config"

	# Finally, point KUBECONFIG to the merged file
	export KUBECONFIG="$HOME/.kube/merged-config"
	if [[ $1 =~ '-v' ]]; then; echo "Merged kubeconfig saved to ~/.kube/merged-config"; fi
}

# shorten aliases
alias kcm='kubeconfig-merge -v'

# run on starting shell
kubeconfig-merge
