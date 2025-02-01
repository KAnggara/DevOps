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
		echo $APPLICATION_PROPERTIES | base64 --decode >src/main/resources/application.yaml
	fi
	cat src/main/resources/application.yaml
	pwd
	ls -la
}

main() {
	override_config
}

main || abort "override config Execute Error!"
