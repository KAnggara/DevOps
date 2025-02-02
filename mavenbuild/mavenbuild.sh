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

maven_build() {
	echo "MVN Build"
	pwd
	ls -la

	mvn --batch-mode --update-snapshots verify
	ls -la

	ls -la $GITHUB_WORKSPACE
	echo "Create folder"
	mkdir $GITHUB_WORKSPACE/mavenbuild
	ls -la $GITHUB_WORKSPACE

	ls -la $GITHUB_WORKSPACE/mavenbuild
	echo "Copy Jar"
	cp target/*.jar $GITHUB_WORKSPACE/mavenbuild
	cd $GITHUB_WORKSPACE/mavenbuild
	pwd
	ls -la
}

main() {
	override_config
	maven_build
}

main || abort "override config Execute Error!"
