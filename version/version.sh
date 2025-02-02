#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@"
	exit 1
}

versioning() {
	mkdir -p version
	echo $GitVersion_SemVer >version/FullSemVer.txt
	echo $GitVersion_MajorMinorPatch >version/MajorMinorPatch.txt
}

main() {
	versioning
}

main || abort "Versioning Execute Error!"
