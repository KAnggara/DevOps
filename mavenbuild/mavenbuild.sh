#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@"
	exit 1
}

override_config() {
	pwd
	if [[ -n "$WORK_DIR" ]]; then
		cd $WORK_DIR
	fi
	pwd

	if [[ -n "$APPLICATION_PROPERTIES" ]]; then
		if [[ -f src/main/resources/application.properties ]]; then
			printf "%s" "$APPLICATION_PROPERTIES" >src/main/resources/application.properties
		elif [[ -f src/main/resources/application.yaml ]]; then
			printf "%s" "$APPLICATION_PROPERTIES" >src/main/resources/application.yaml
		else
			abort "Error: application.yaml or application.properties not found!"
		fi
	else
		echo "APPLICATION_PROPERTIES var not exist, keep it as is"
	fi

}

maven_build() {
	echo "MVN Build"
	pwd
	mvn --batch-mode --update-snapshots verify
	ls -la
	mkdir $GITHUB_WORKSPACE/staging
	echo $GITHUB_WORKSPACE
	ls -la
	cp target/*.jar $GITHUB_WORKSPACE/staging
	cd $GITHUB_WORKSPACE/staging
	ls -la
}

main() {
	pwd
	cd $GITHUB_WORKSPACE
	override_config
	maven_build
}

main || abort "override config Execute Error!"
