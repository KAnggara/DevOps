function delete_image() {
	if [[ -z "$1" ]]; then
		abort "Error: Parameter 'id' required!"
	fi

	if [[ -z "$2" ]]; then
		abort "Error: Parameter 'name' required!"
	fi

	local id=$1
	local IMAGE_NAME=$2
	local TAG=${3:-}

	echo -e "🔥 Delete\t: $id \t"DELETE"\t $TAG"

	# gh api --method DELETE "/orgs/$ORG_NAME/packages/container/$IMAGE_NAME/versions/$id"
}
