#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@"
	exit 1
}

override_config() {
	if [[ -n "$APPLICATION_PROPERTIES" ]]; then
		if [[ -f src/main/resources/application.properties ]]; then
			printf "%s" "$APPLICATION_PROPERTIES" >src/main/resources/application.properties
		elif [[ -f src/main/resources/application.yaml ]]; then
			printf "%s" "$APPLICATION_PROPERTIES" >src/main/resources/application.yaml
		else
			abort "Error: application.yaml or application.properties not found!"
		fi
	fi
}

main() {
	override_config
}

main || abort "override config Execute Error!"
