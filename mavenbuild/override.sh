#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@"
	exit 1
}

override_config() {
	if [[ -z "$APPLICATION_PROPERTIES" ]]; then
		echo "Variabel kosong"
	else
		echo "Variabel tidak kosong: $APPLICATION_PROPERTIES"
	fi
	pwd
	ls -la
}

main() {
	override_config
}

main || abort "override config Execute Error!"
