#!/bin/bash
set -eu

SHORT_SHA=$(echo $SHA | head -c 7)

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
		echo "$PASSWORD" | docker login -u $USERNAME --password-stdin $REGISTRY
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
		docker build . -t $REGISTRY/$IMAGE_NAME:release-$DATE -t $REGISTRY/$IMAGE_NAME:latest
	elif [[ "$BRANCH" == "feature-"* ]]; then
		docker build . -t $REGISTRY/$IMAGE_NAME:sit-$SHORT_SHA -t $REGISTRY/$IMAGE_NAME:latest
	else
		docker build . -t $REGISTRY/$IMAGE_NAME:dev-$SHORT_SHA -t $REGISTRY/$IMAGE_NAME:latest
	fi

	docker push --all-tags $REGISTRY/$IMAGE_NAME
}

main() {
	login
	docker_build
}

main || abort "Docker Build Execute Error!"
