#!/usr/bin/env zsh

SCRIPT_PATH="$0"

# to reach the card: https://<site>.atlassian.net/browse/<issue-key>
JIRA_BASE_URL=

function jira() {
	if [[ $JIRA_BASE_URL = '' ]]; then
		echo 'JIRA_BASE_URL is not set.'
		echo "Please set it first in $SCRIPT_PATH"
		return 1
	fi
	for card in $@; do
		open $JIRA_BASE_URL/browse/$card
	done
}
