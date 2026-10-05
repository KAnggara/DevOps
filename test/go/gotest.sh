#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@" >&2
	exit 1
}

override_config() {
	if [[ -n "${WORK_DIR:-}" ]]; then
		cd "${WORK_DIR}" || abort "Workdir tidak ditemukan: ${WORK_DIR}"
	fi

	if [[ -n "${DOTENV:-}" ]]; then
		if [[ -f .env ]]; then
			echo "Rewrite .env"
			printf "%s\n" "$DOTENV" >.env
		elif [[ -f .env.example ]]; then
			echo "Copy .env.example to .env"
			cp .env.example .env
		else
			echo "Create .env"
			printf "%s\n" "$DOTENV" >.env
		fi
	elif [[ -f .env ]]; then
		echo "DOTENV var not exist, keep it as is"
	elif [[ -f .env.example ]]; then
		echo "Copy .env.example to .env"
		cp .env.example .env
	else
		echo "DOTENV var not exist, keep it as is"
	fi
}

go_test() {
	echo "Go Test"
	go version
	if [[ -f go.mod ]]; then
		go mod download
	fi

	if [[ "${COVERAGE:-false}" == "true" ]]; then
		echo "Running tests with coverage..."
		go test -v -coverprofile=coverage.out ./...
	else
		go test -v ./...
	fi
}

main() {
	override_config
	go_test
}

main || abort "Go test Execute Error!"
