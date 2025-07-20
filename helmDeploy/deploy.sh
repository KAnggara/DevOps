#!/bin/bash
set -euo pipefail

abort() {
	printf "%s\n" "$@"
	exit 1
}

REF_BASE=${1:-HEAD~1}
REF_HEAD=${2:-HEAD}

update_chart_yaml(){
  local FOLDER=$1
  local GIT_VERSION=$FullSemVer
	CHART_FILE="Chart.yaml"

  [[ -f "$CHART_FILE" ]] || abort "Chart.yaml tidak ditemukan"
	pwd
	ls -la

	sed -E -i "s/^(version:[[:space:]]*).*/\1${GIT_VERSION}/" "$CHART_FILE"
	sed -E -i "s/^(name:[[:space:]]*).*/\1${FOLDER}/" "$CHART_FILE"

	git update-index --assume-unchanged "$CHART_FILE"
}

main() {
	IFS=$'\n' read -r -d '' -a folders < <(git diff --name-only "$REF_BASE" "$REF_HEAD" | grep -E '/values\.yaml$' | awk -F/ '{print $1}' | sort -u && printf '\0')

	if (( ${#folders[@]} > 1 )); then
    echo "Error: Ditemukan lebih dari satu folder dengan values.yaml yang berubah:" >&2
    printf " - %s\n" "${folders[@]}" >&2
    exit 1
  fi

	if (( ${#folders[@]} == 0 )); then
    echo "ℹ️  Tidak ada folder level-1 dengan values.yaml berubah antara $REF_BASE dan $REF_HEAD."
    exit 0
  fi

	update_chart_yaml "${folders[0]}"
	echo "Preparing for deploy ${folders[0]}"
	cp "${folders[0]}/values.yaml" ./values.yaml
}


main || abort "Versioning Execute Error!"
