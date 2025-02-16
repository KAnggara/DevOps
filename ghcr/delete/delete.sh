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
		echo $GITHUB_TOKEN | gh auth login --with-token
	fi
}

main() {
	login
}

main || abort "GHCR Delete Execute Error!"
