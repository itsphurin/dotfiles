#!/usr/bin/env zsh
[[ -f /etc/os-release ]] && . /etc/os-release

TPM_PATH=~/.tmux/plugins/tpm

echo "\n<<< Starting Tmux Plugin Manager Setup >>>\n"

if ls $TPM_PATH >/dev/null 2>&1; then
	echo "tpm exists, skipping install"
else
	echo "tpm doesn't exist, continuing with install"
	git clone https://github.com/tmux-plugins/tpm $TPM_PATH
	pip3 install --break-system-packages --user 'git+https://github.com/tmux-python/libtmux.git'
fi

if exists tmuxinator; then
	echo "tmuxinator exists, skipping install"
else
	echo "tmuxinator doesn't exist, continuing with install"
	if [[ $ID == "arch" ]]; then
		yay -S tmuxinator
		completion_path='/usr/local/share/zsh/site-functions'
		if [[ ! -f "$completion_path/_tmuxinator" ]]; then
			echo "installing tmuxinator completion"
			sudo mkdir -p $completion_path
			sudo wget https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh -O "$completion_path/_tmuxinator"
		fi
	else
	fi
fi
