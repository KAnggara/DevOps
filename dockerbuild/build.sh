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

	IMAGE_NAME=$(echo "$IMAGE_NAME" | sed 's/.*/\L&/')

	echo "Branch nya adalah $BRANCH"

	if [[ "$BRANCH" == "main" || "$BRANCH" == "master" ]]; then
		DATE=$(TZ=Asia/Jakarta date +"%Y%m%d-%H%M")
		docker build . -t ghcr.io/$IMAGE_NAME:release-$DATE -t ghcr.io/$IMAGE_NAME:latest
		docker push ghcr.io/$IMAGE_NAME:release-$DATE
	elif [[ "$BRANCH" == "feature-"* ]]; then
		docker build . -t ghcr.io/$IMAGE_NAME:sit -t ghcr.io/$IMAGE_NAME:latest
		docker push ghcr.io/$IMAGE_NAME:sit
	else
		docker build . -t ghcr.io/$IMAGE_NAME:dev -t ghcr.io/$IMAGE_NAME:latest
		docker push ghcr.io/$IMAGE_NAME:dev
	fi

	docker push ghcr.io/$IMAGE_NAME:latest
}

main() {
	login
	docker_build
}

main || abort "Docker Build Execute Error!"
