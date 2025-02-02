#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@"
	exit 1
}

versioning() {
	mkdir -p gitversion
	echo $GitVersion_ShortSha >gitversion/ShortSha.txt
	echo $GitVersion_SemVer >gitversion/FullSemVer.txt
	echo $GitVersion_CommitDate >gitversion/CommitDate.txt
	echo $GitVersion_MajorMinorPatch >gitversion/MajorMinorPatch.txt
}

main() {
	versioning
}

main || abort "Versioning Execute Error!"
