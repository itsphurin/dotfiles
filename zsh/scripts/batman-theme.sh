#!/usr/bin/env zsh

if [[ "$OSTYPE" == "darwin"* ]]; then
	current_theme=$(defaults read -g AppleInterfaceStyle /dev/null 2>&1)
	if [[ "$current_theme" == "Dark" ]]; then
		alias man="update_man_width;BAT_THEME='Monokai Extended' batman '$@'"
	else
		alias man="update_man_width;BAT_THEME='Monokai Extended Light' batman '$@'"
	fi
fi
