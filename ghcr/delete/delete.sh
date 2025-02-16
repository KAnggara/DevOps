#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@"
	exit 1
}

login() {
	if [[ -z "$GITHUB_TOKEN" ]]; then
		abort "Token is Required!"
	else
		gh auth login --with-token <<<"$GITHUB_TOKEN"
	fi
}

main() {
	login
}

main || abort "Docker Build Execute Error!"
