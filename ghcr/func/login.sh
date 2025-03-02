function login() {
	echo
	echo "🔑 Login to GitHub..."
	if [[ -z "$GH_TOKEN" ]]; then
		abort "Token is Required!"
	else
		echo "$GH_TOKEN" | gh auth login --with-token >/dev/null 2>/dev/null
	fi
}
