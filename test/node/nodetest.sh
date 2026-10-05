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

node_test() {
	echo "Node Test"
	node -v
	npm -v

	if [[ -f package-lock.json ]]; then
		echo "Installing dependencies with npm ci..."
		npm ci
	elif [[ -f package.json ]]; then
		echo "Installing dependencies with npm install..."
		npm install
	fi

	local cmd="${TEST_COMMAND:-npm test}"
	echo "Running test command: ${cmd}"
	eval "${cmd}"
}

main() {
	override_config
	node_test
}

main || abort "Node test Execute Error!"
