#!/bin/bash

set -eu

RELEASE_COUNT=0
NON_RELEASE_COUNT=0

abort() {
	printf "%s\n" "$@"
	exit 1
}

load() {
	eval "$(curl -Ls -H "${GH_TOKEN}" ${FUNCTION_URL}/gh_login.sh)"
	eval "$(curl -Ls -H "${GH_TOKEN}" ${FUNCTION_URL}/get_version.sh)"
	eval "$(curl -Ls -H "${GH_TOKEN}" ${FUNCTION_URL}/delete_image.sh)"
}

setup() {
	if [[ -z "$ORG_NAME" ]]; then
		abort "Org/Username is Required!"
	elif [[ -z "$REPO_NAME" ]]; then
		abort "Repository is Required!"
	fi

	if [[ -z "$KEEP_RELEASE" ]]; then
		KEEP_RELEASE=5
	fi

	if [[ -z "$KEEP_NON_RELEASE" ]]; then
		KEEP_NON_RELEASE=2
	fi

	echo "🛑 Keep latest $KEEP_NON_RELEASE non release and $KEEP_RELEASE release images..."
	echo
}

check_tag() {
	echo "$VERSIONS" | jq -c '.[]' | while read -r VERSION; do
		local IS_RELEASE=false
		local IS_NON_RELEASE=false

		local TAGS=$(echo "$VERSION" | jq -r '.metadata.container.tags[]' | tr '\n' ' ')

		local VERSION_ID=$(echo "$VERSION" | jq -r '.id')

		if [[ "$TAGS" == *"release"* ]]; then
			IS_RELEASE=true
			((RELEASE_COUNT++))
		elif [[ "$TAGS" == *"feature-"* ]]; then
			IS_NON_RELEASE=true
			((NON_RELEASE_COUNT++))
		else
			IS_NON_RELEASE=true
			((NON_RELEASE_COUNT++))
		fi

		if [[ ($NON_RELEASE_COUNT -gt $KEEP_NON_RELEASE && "$IS_NON_RELEASE" == true) || ($RELEASE_COUNT -gt $KEEP_RELEASE && "$IS_RELEASE" == true) ]]; then
			local IMAGE_NAME=$(echo "$VERSION" | jq -r '.name')
			delete_image $VERSION_ID $IMAGE_NAME $TAGS
		else
			echo -e "⏭️ Keep\t\t: $VERSION_ID \t"SAVE"\t $TAGS"
		fi

	done
}

main() {
	load
	setup
	gh_login
	get_package_list
	check_tag
}

main || abort "An error occurred, exiting."
