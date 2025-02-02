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
		echo "$PASSWORD" | docker login -u $USERNAME --password-stdin ghcr.io
	fi
}

docker_build() {
	if [[ -n "$WORK_DIR" ]]; then
		cd $WORK_DIR
	fi

	docker build . --tag ghcr.io/$IMAGE_NAME:latest
	docker push ghcr.io/$IMAGE_NAME:latest

}

main() {
	login
	docker_build
}

main || abort "Docker Build Execute Error!"
