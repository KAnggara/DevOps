#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@"
	exit 1
}

override_config() {
	if [[ -n "$APPLICATION_PROPERTIES" ]]; then
		printf "%s" "$APPLICATION_PROPERTIES" >src/main/resources/application.yaml
	fi

	cat src/main/resources/application.yaml

	pwd

	ls -la
}

main() {
	override_config
}

main || abort "override config Execute Error!"
