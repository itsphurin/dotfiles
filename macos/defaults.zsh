#!/usr/bin/env zsh

# to reset configuration
# `defaults delete -g ApplePressAndHoldEnabled` or `defaults delete NSGlobalDomain ApplePressAndHoldEnabled`
# to reset all configurations use
# `defaults delete -g` or `defaults delete NSGlobalDomain`

# defaults delete -g KeyRepeat
# defaults delete -g InitialKeyRepeat
# บางกรณีต้องลบที่ currentHost ด้วย:
# defaults -currentHost delete -g KeyRepeat
# defaults -currentHost delete -g InitialKeyRepeat

# to read configs
# defaults read -g KeyRepeat
# defaults read -g InitialKeyRepeat

echo -n '[1/2] disabling ApplePressAndHoldEnabled...'
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
echo 'OK'

echo -n '[2/2] adjusting InitialKeyRepeat and KeyRepeat...'
# See https://apple.stackexchange.com/questions/10467/how-to-increase-keyboard-key-repeat-rate-on-os-x/83923#83923
# My default comfortable is KeyRepeat = 2, InitialKeyRepeat = 15
# For ADHD's is  KeyRepeat = 1, InitialKeyRepeat = 9
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
echo 'OK'

echo "\nCompleted macos configuration with 'defaults' command.\n"
