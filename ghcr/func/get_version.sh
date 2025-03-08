function get_package_list() {
	echo
	local IS_ORG

	echo "Check $ORG_NAME/$REPO_NAME..."
	IS_ORG=$(gh repo view $ORG_NAME/$REPO_NAME --json isInOrganization | jq .isInOrganization)

	echo "Get Package versions..."
	echo
	if [[ "$IS_ORG" == true ]]; then
		VERSIONS=$(gh api --paginate "/orgs/$ORG_NAME/packages/container/$REPO_NAME/versions")
	else
		VERSIONS=$(gh api --paginate "/users/$ORG_NAME/packages/container/$REPO_NAME/versions")
	fi

	STATUS=$(echo "$VERSIONS" | jq -r 'try .status catch "200"')

	if [[ $STATUS == "404" ]]; then
		echo "🚀 No Image on $ORG_NAME/$REPO_NAME."
		exit 0
	fi
}
