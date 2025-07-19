#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@"
	exit 1
}

logout_ghcr() {
	gh auth logout
}

main() {
	logout_ghcr
	echo "Logout from GHCR"
}

main || abort "Post Run Execute Error!"
