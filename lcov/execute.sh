#!/bin/bash
set -eu

abort() {
	printf "%s\n" "$@"
	exit 1
}

install_lcov() {
	pwd
	ls -la
	mkdir $GITHUB_WORKSPACE/$OUTDIR
	ls -la
	cd $WD
	pwd
	genhtml $COVERAGE_FILE --rc branch_coverage=1 -o $GITHUB_WORKSPACE/$OUTDIR
	ls -la
	cd $GITHUB_WORKSPACE/$OUTDIR
	ls -la
	pwd
}

main() {
	execute_lcov
}

main || abort "LCOV Setup Error!"
