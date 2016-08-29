#!/bin/sh

set -o | grep "^posixargzero" > /dev/null && set -o posixargzero


# Import all the files
# shellcheck disable=SC2044
for src_file in $(find "$(dirname "$0")/core" -name '*.sh'); do
	. "$src_file"
done

# Add all tests to the suite
# shellcheck disable=SC2013,SC2044
suite() {
	for src_file in $(find "$(dirname "$0")/core" -name '*.sh' | sort); do
		for tst in $(grep "test.*()" "$src_file" | cut -d'(' -f1); do
			suite_addTest "$tst"
		done
	done
}

# shellcheck disable=SC2034,SC2044
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
	for fil in $(find "$_BASEDIR/core" -name '*.sh'); do
		inc=${fil#$_BASEDIR/}
		include "${inc%.sh}"
	done
}

tearDown() {
	# Delete log
	rm -rf "$ENSHURE_LOG"
}

. "$(dirname "$0")/shunit2"

