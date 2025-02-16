#!/bin/bash
set -eu

KEEP=6
DAYS=60
KEEP_RELEASE=2

COUNT=0
RELEASE_COUNT=0

VERSIONS=

REMOVE_VERSION=false
TIMESTAMP_NOW=$(date +%s)

abort() {
	printf "%s\n" "$@"
	exit 1
}

login() {
	if [[ -z "$GH_TOKEN" ]]; then
		abort "Token is Required!"
	else
		echo "$GH_TOKEN" | gh auth login --with-token >/dev/null 2>/dev/null
	fi
}

setup() {
	if [[ -z "$ORG_NAME" ]]; then
		abort "Org/Username is Required!"
	elif [[ -z "$REPO_NAME" ]]; then
		abort "Repository is Required!"
	fi

	if [[ -n "$KEEP_LATEST" ]]; then
		KEEP=$KEEP_LATEST
	fi

	if [[ -n "$RETENTION_DAYS" ]]; then
		DAYS=$RETENTION_DAYS
	fi

	echo "🛑 Delete images $DAYS days old, Keep latest $KEEP images..."
	echo
}

get_version() {
	local IS_ORG

	IS_ORG=$(gh repo view $ORG_NAME/$REPO_NAME --json isInOrganization | jq .isInOrganization)

	if [[ "$IS_ORG" == true ]]; then
		VERSIONS=$(gh api --paginate "/orgs/$ORG_NAME/packages/container/$REPO_NAME/versions")
	else
		VERSIONS=$(gh api --paginate "/users/$ORG_NAME/packages/container/$REPO_NAME/versions")
	fi

	if [[ -z "$VERSIONS" ]]; then
		echo "🚀 No Image on $ORG_NAME/$REPO_NAME."
		exit 0
	fi
}

filter_version() {
	echo "$VERSIONS" | jq -c '.[]' | while read -r VERSION; do
		IS_LATEST=false
		IS_RELEASE=false
		REMOVE_RELEASE=false

		VERSION_ID=$(echo "$VERSION" | jq -r '.id')
		TAGS=$(echo "$VERSION" | jq -r '.metadata.container.tags[]')

		if [[ "$TAGS" == *"release"* ]]; then
			CREATED_AT=$(echo "$VERSION" | jq -r '.created_at')
			TIMESTAMP_CREATED_AT=$(date -d "$CREATED_AT" +%s)

			DIFF_DAYS=$(((TIMESTAMP_NOW - TIMESTAMP_CREATED_AT) / 86400))

			IS_RELEASE=true
		fi

		if [[ "$IS_RELEASE" == true ]]; then

			((COUNT--))
			if [[ "$DAYS" -gt "$DIFF_DAYS" ]]; then
				echo "⏭️ Build date $CREATED_AT is still within the last $DAYS days. Keep Release: $VERSION_ID"
			else
				((RELEASE_COUNT++))
			fi

			if [[ $RELEASE_COUNT -gt $KEEP_RELEASE ]]; then
				REMOVE_RELEASE=true
			fi
		fi

		if [[ "$TAGS" == *"latest"* ]]; then
			IS_LATEST=true
		fi

		((COUNT++))
		if [[ "$IS_LATEST" == true ]]; then
			echo "⏭️ Keep Latest image: $VERSION_ID"
		elif [[ $COUNT -gt $KEEP || "$REMOVE_RELEASE" == true ]]; then
			remove_image $VERSION_ID $TAGS "D" $COUNT $RELEASE_COUNT
		else
			echo "⏭️ Keep  : $VERSION_ID $COUNT $RELEASE_COUNT "S" $TAGS"
		fi

	done
}

remove_image() {
	if [[ -z "$1" ]]; then
		abort "Error: Parameter 'a' required!"
	fi

	local id=$1
	local tag=${2:-}
	local tiga=${3:-}
	local COUNT=${4:-}
	local RELEASE_COUNT=${5:-}

	echo "🔥 Delete: $id $COUNT $RELEASE_COUNT $tiga $tag"

	# gh api --method DELETE "/orgs/$ORG_NAME/packages/container/$IMAGE_NAME/versions/$id"
}

main() {
	clear
	login
	setup
	get_version
	filter_version

	echo
	echo "✅ Clean Up Done! 🎉"
}

main || abort "GHCR Delete Execute Error!"
