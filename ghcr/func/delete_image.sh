function delete_image() {
	if [[ -z "$1" ]]; then
		abort "Error: Parameter 'id' required!"
	fi

	local id=$1
	local tag=${2:-}
	local tiga=${3:-}
	local COUNT=${4:-}
	local RELEASE_COUNT=${5:-}

	echo -e "🔥 Delete\t: $id \t"DELETE"\t $tag"

	# gh api --method DELETE "/orgs/$ORG_NAME/packages/container/$IMAGE_NAME/versions/$id"
}
