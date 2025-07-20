#!/bin/bash
set -euo pipefail

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

check_changes() {
	REF_BASE=$ {1:-HEAD~1}
	REF_HEAD=$ {2:-HEAD}

	changed_files=$(git diff --name-only "$REF_BASE" "$REF_HEAD")

	if echo "$changed_files" | grep -qx 'values.yaml'; then
		echo "File 'values.yaml' terdeteksi berubah antara $REF_BASE dan $REF_HEAD."
		exit 0
	else
		echo "Tidak ada perubahan pada 'values.yaml' antara $REF_BASE dan $REF_HEAD."
		exit 1
	fi
}

main() {
	versioning
	check_changes
}

main || abort "Versioning Execute Error!"
