#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@"
	exit 1
}

execute_lcov() {
	mkdir $GITHUB_WORKSPACE/$OUTDIR
	cd $WD
	genhtml $COVERAGE_FILE --rc branch_coverage=1 -o $GITHUB_WORKSPACE/$OUTDIR
}

main() {
	execute_lcov
}

main || abort "LCOV Execute Error!"
