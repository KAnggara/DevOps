#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@"
	exit 1
}

login() {
	if [[ -z "$USERNAME" ]]; then
		abort "Username is Required!"
	elif [[ -z "$PASSWORD" ]]; then
		abort "Password is Required!"
	else
		docker login --username $USERNAME --password $PASSWORD ghcr.io
	fi
}

docker_build() {
	if [[ -n "$WORK_DIR" ]]; then
		cd $WORK_DIR
	fi

	docker -v

}

main() {
	login
	docker_build
}

main || abort "Docker Build Execute Error!"
