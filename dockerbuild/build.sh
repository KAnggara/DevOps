#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@"
	exit 1
}

docker_build() {
	if [[ -n "$WORK_DIR" ]]; then
		cd $WORK_DIR
	fi

	docker -v

}

main() {
	docker_build
}

main || abort "Docker Build Execute Error!"
