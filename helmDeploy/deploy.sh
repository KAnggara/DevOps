#!/usr/bin/env bash
set -euo pipefail

abort() {
	printf "%s\n" "$@" >&2
	exit 1
}

REF_BASE=${1:-HEAD~1}
REF_HEAD=${2:-HEAD}

CHART_DIR="./chart"
APPS_DIR="./apps"

update_chart_yaml(){
  local APP_NAME=$1
  local GIT_VERSION=${GitVersion_SemVer:-"0.1.0"}
  local CHART_FILE="${CHART_DIR}/Chart.yaml"

  [[ -f "$CHART_FILE" ]] || abort "Chart.yaml tidak ditemukan di $CHART_DIR"

  sed -E -i "s/^(version:[[:space:]]*).*/\1${GIT_VERSION}/" "$CHART_FILE"
  sed -E -i "s/^(name:[[:space:]]*).*/\1${APP_NAME}/" "$CHART_FILE"
}

setup_kubectl() {
	if [[ -z "${KUBECONFIG_DATA:-}" ]]; then
		abort "KUBECONFIG_DATA tidak diset"
	fi

	echo "Restoring kubeconfig"
	mkdir -p "$HOME/.kube"
	echo "$KUBECONFIG_DATA" | base64 -d > "$HOME/.kube/config"
	chmod 600 "$HOME/.kube/config"
}

detect_changed_apps() {
	git diff --name-only "$REF_BASE" "$REF_HEAD" \
		| grep -E '^apps/.*\.yaml$' \
		| awk -F/ '{print $2}' \
		| sed 's/.yaml$//' \
		| sort -u
}

deploy_app() {
	local APP_NAME=$1
	local VALUES_FILE="${APPS_DIR}/${APP_NAME}.yaml"

	echo ""
	echo "=== Deploying $APP_NAME ==="

	[[ -f "$VALUES_FILE" ]] || abort "File $VALUES_FILE tidak ditemukan"

	helm upgrade --install "$APP_NAME" "$CHART_DIR" \
		-f "$VALUES_FILE" \
		--namespace default \
		--create-namespace \
		--atomic \
		--timeout 5m

	echo "✔️  Deploy $APP_NAME selesai"
}

main() {
	mapfile -t apps < <(detect_changed_apps)

	if (( ${#apps[@]} == 0 )); then
		echo "ℹ️  Tidak ada perubahan di folder apps/"
		exit 0
	fi

	if (( ${#apps[@]} > 1 )); then
		echo "⚠️  Multiple apps berubah:"
		printf " - %s\n" "${apps[@]}"
	fi

	setup_kubectl

	for app in "${apps[@]}"; do
		update_chart_yaml "$app"
		deploy_app "$app"
	done
}

main || abort "Deploy gagal!"
