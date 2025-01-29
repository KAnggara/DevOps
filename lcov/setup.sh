#!/bin/bash
set -eu

OS_NAME=$(echo "$RUNNER_OS" | awk '{print tolower($0)}')

abort() {
	printf "%s\n" "$@"
	exit 1
}

install_lcov() {
	echo $OS_NAME
	if [[ $OS_NAME =~ ^"linux" ]]; then
		sudo apt install lcov -y >/dev/null 2>&1
	elif [[ $OS_NAME =~ ^"darwin" ]]; then
		brew install lcov >/dev/null 2>&1
	else
		echo "Unsupport Runner OS: $OS_NAME"
		exit 1
	fi
}

main() {
	install_lcov
}

main || abort "LCOV Setup Error!"
