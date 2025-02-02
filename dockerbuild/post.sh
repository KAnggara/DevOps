#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@"
	exit 1
}

logout_docker() {
	docker logout
}

main() {
	logout_docker
}

main || abort "Post Run Execute Error!"
