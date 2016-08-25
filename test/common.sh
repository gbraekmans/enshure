#!/bin/bash

set -o | grep "^posixargzero" > /dev/null && set -o posixargzero

setUp() {
	# Freeze time for logs
	date() {
		printf '1970-01-01 00:00:00'
	}
	
	# Reset env variables
	ENSHURE_LOG=$(mktemp)
	ENSHURE_VERBOSITY=
	
	# Include all source files
	_INCLUDED=
	_BASEDIR="$(dirname -- "$0")/../src"
	. "$_BASEDIR/core/base.sh"
	include core/log
	include core/help
	include core/main
	include core/version
}

tearDown() {
	# Delete log
	rm -rf "$ENSHURE_LOG"
}

. "/usr/share/shunit2/shunit2"
