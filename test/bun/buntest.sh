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

	if [[ -n "$DOTENV" ]]; then
		if [[ -f .env ]]; then
			echo "Rewrite .env"
			printf "%s" "$DOTENV" >.env
		elif [[ -f .env.example ]]; then
			echo "Copy .env.example to .env"
			cp .env.example .env
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

bun_test() {
	echo "Bun Test"
	bun -v
	bun install
	bun test
}

main() {
	override_config
	bun_test
}

main || abort "Override config Execute Error!"
