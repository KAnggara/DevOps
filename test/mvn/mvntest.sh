#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@"
	exit 1
}

override_config() {
	if [[ -n "$WORK_DIR" ]]; then
		cd $WORK_DIR
	fi

	if [[ "${OVERRIDE_PROPERTIES:-false}" != "true" ]]; then
			echo "Skipping override_config karena OVERRIDE_PROPERTIES != true"
			return
	fi

	if [[ -n "$APPLICATION_PROPERTIES" ]]; then
		if [[ -f src/main/resources/application.properties ]]; then
			echo "Rewrite application.properties"
			printf "%s" "$APPLICATION_PROPERTIES" >src/main/resources/application.properties
		elif [[ -f src/main/resources/application.yaml ]]; then
			echo "Rewrite application.yaml"
			printf "%s" "$APPLICATION_PROPERTIES" >src/main/resources/application.yaml
		elif [[ -f src/main/resources/application.yml ]]; then
			echo "Rewrite application.yml"
			printf "%s" "$APPLICATION_PROPERTIES" >src/main/resources/application.yml
		else
			abort "Error: application.yaml/yml or application.properties not found!"
		fi
	else
		echo "APPLICATION_PROPERTIES var not exist, keep it as is"
	fi

}

maven_test() {
	echo "MVN Test"
	mvn clean test
}

main() {
	override_config
	maven_test
}

main || abort "Override config Execute Error!"
