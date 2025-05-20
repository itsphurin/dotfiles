#!/usr/bin/env zsh

echo "\n<<< Starting oh-my-zsh Setup >>>\n"

if command ls ~/.oh-my-zsh >/dev/null 2>&1; then
	echo "omz exists, skipping install"
else
	curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | /bin/zsh
	echo -n "removing .zshrc from omz: "
	rm ~/.zshrc && echo "DONE" || echo "FAILED"
	echo -n "replacing with symlink: "
	ln -s $(pwd)/zsh/zshrc ~/.zshrc && echo "DONE" || echo "FAILED"
	echo -n "resourcing sourcefile: "
	source ~/.zshrc && echo "DONE" || echo "FAILED"

	echo -n "installing custom plugins: "
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	# git clone https://github.com/zsh-users/zsh-completions.git ~/.oh-my-zsh/custom/plugins/zsh-completions
	git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.oh-my-zsh/custom/plugins/zsh-autocomplete
	echo "DONE"
fi
