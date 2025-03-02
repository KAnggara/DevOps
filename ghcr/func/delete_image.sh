function delete_image() {
	if [[ -z "$1" ]]; then
		abort "Error: Parameter 'id' required!"
	fi

	local id=$1
	local TAG=${2:-}

	echo -e "🔥 Delete\t: $id \t"DELETE"\t $TAG"

	gh api --method DELETE "/orgs/$ORG_NAME/packages/container/$REPO_NAME/versions/$id"
}
