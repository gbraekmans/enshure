#!/bin/bash

set -o | grep "^posixargzero" > /dev/null && set -o posixargzero

# shellcheck disable=SC2034
setUp() {	
	# Freeze time for logs
	date() {
		printf '1970-01-01 00:00:00'
	}
	# Run as root for logs
	id() {
		printf '0'
	}
	
	# Reset env variables
	ENSHURE_LOG=$(mktemp)
	ENSHURE_VERBOSITY=
	
	# Reset important test variables
	_INCLUDED=
	_MODULE=
	_IDENTIFIER=
	_REQUESTED_STATE=

	# Include all source files
	_BASEDIR="$(dirname -- "$0")/../src"
	. "$_BASEDIR/core/base.sh"
	include core/log
	include core/help
	include core/main
	include core/version
	include core/task
	include core/run
	include core/query
}

tearDown() {
	# Delete log
	rm -rf "$ENSHURE_LOG"
}

. "$(dirname "$0")/shunit2"
