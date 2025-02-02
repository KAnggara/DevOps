#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@"
	exit 1
}

versioning() {
	mkdir -p version
	echo $FullSemVer >version/FullSemVer.txt
	echo $MajorMinorPatch >version/MajorMinorPatch.txt
}

main() {
	versioning
}

main || abort "Versioning Execute Error!"
