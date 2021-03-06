#!/bin/sh

test_is_available() {
	is_available ls
	assertTrue 1 "$?"
	is_available foo
	assertFalse 2 "$?"
}

test_require() {
	require ls
	assertTrue 1 "$?"
	RESULT=$(require foo)
	assertFalse 2 "$?"
	assertEquals 3 "ERROR: enSHure requires 'foo' to be installed." "$RESULT"
}

test_error() {
	RESULT=$(error "test")
	assertTrue 1 "$?"
	assertEquals 2 "ERROR: test" "$RESULT"
	assertEquals 3 "#ERROR|1970-01-01 00:00:00|0||||test" "$(cat "$ENSHURE_LOG")"
}

test_warning() {
	RESULT=$(warning "test")
	assertTrue 1 "$?"
	assertEquals 2 "WARNING: test" "$RESULT"
	assertEquals 3 "#WARNING|1970-01-01 00:00:00|0||||test" "$(cat "$ENSHURE_LOG")"
}

test_info() {
	RESULT=$(info "test")
	assertTrue 1 "$?"
	assertEquals 2 "INFO: test" "$RESULT"
	assertEquals 3 "#INFO|1970-01-01 00:00:00|0||||test" "$(cat "$ENSHURE_LOG")"
}

# shellcheck disable=SC2034
test_debug() {
	# Loglevel DEBUG, should log and print
	# shellcheck disable=SC2034
	ENSHURE_VERBOSITY="DEBUG"
	RESULT=$(debug "test" log)
	assertTrue 1 "$?"
	assertEquals 2 "DEBUG: test" "$RESULT"
	assertEquals 3 "#DEBUG|1970-01-01 00:00:00|0||||test" "$(cat "$ENSHURE_LOG")"
	unset ENSHURE_VERBOSITY
	printf '' > "$ENSHURE_LOG"

	# Loglevel INFO, should log but not print
	RESULT=$(debug "test2" log)
	assertTrue 4 "$?"
	assertEquals 5 "" "$RESULT"
	assertEquals 6 "#DEBUG|1970-01-01 00:00:00|0||||test2" "$(cat "$ENSHURE_LOG")"
	printf '' > "$ENSHURE_LOG"

	# Should print but not log
	ENSHURE_VERBOSITY="DEBUG"
	RESULT=$(debug "test3")
	assertTrue 7 "$?"
	assertEquals 8 "DEBUG: test3" "$RESULT"
	assertEquals 9 "" "$(cat "$ENSHURE_LOG")"

	unset ENSHURE_VERBOSITY
}

test_include() {
	# Reset included, don't do this if not testing ;)
	_INCLUDED=
	_VERSION=
	test -n "$_VERSION"
	assertFalse 5 "$?"
	include core/version
	assertTrue 1 "$?"
	assertEquals 2 "core/base:core/version" "$_INCLUDED"
	test -n "$_VERSION"
	assertTrue 3 "$?"
	include core/version
	assertTrue 4 "$?"
	assertEquals 5 "core/base:core/version" "$_INCLUDED"
	include core/error
	assertEquals 6 "core/base:core/version:core/error" "$_INCLUDED"
	include whatever
	assertFalse 7 "$?"
}

test_not_implemented() {
	RESULT=$(not_implemented)
	assertFalse 1 "$?"
	assertEquals 2 "ERROR: This functionality is not yet implemented in the enSHure core." "$RESULT"

	# shellcheck disable=SC2034
	{
	_MODULE="apt_package"
	_REQUESTED_STATE="present"
	}
	RESULT=$(not_implemented)
	assertFalse 3 "$?"
	assertEquals 4 "ERROR: apt_package does not implement a function needed to set the state 'present'." "$RESULT"
}

test_initcap() {
	RESULT=$(initcap "test")
	assertTrue 1 "$?"
	assertEquals 2 "Test" "$RESULT"

	RESULT=$(initcap "TEST")
	assertTrue 3 "$?"
	assertEquals 4 "Test" "$RESULT"

	RESULT=$(initcap "tEST")
	assertTrue 5 "$?"
	assertEquals 6 "Test" "$RESULT"
}

# shellcheck disable=SC2034 disable=SC2016
test_translate() {
	LANGUAGE='en'
	LANG='en_US.UTF-8'

	RESULT="$(translate "Something unknown went terribly wrong...")"
	assertTrue 1 "$?"
	assertEquals 2 "Something unknown went terribly wrong..." "$RESULT"

	LANGUAGE='C'
	LANG='C'
	RESULT="$(translate "Something unknown went terribly wrong...")"
	assertTrue 3 "$?"
	assertEquals 4 "Something unknown went terribly wrong..." "$RESULT"

	# These tests are only run when using systemd and the NL-locale is available
	if ! [ -e /etc/locale.gen ]; then
		startSkipping
	elif command -v localectl > /dev/null; then
		if ! localectl list-locales | grep -q 'nl_NL.utf8'; then
			startSkipping
		fi
	fi

	LANGUAGE='nl'
	LANG='nl_NL.UTF-8'
	RESULT="$(translate "Something unknown went terribly wrong...")"
	assertTrue 5 "$?"
	assertEquals 6 "Iets onbekend ging helemaal fout..." "$RESULT"

	_display_task='Test'
	RESULT="$(translate 'Done: $_display_task')"
	assertTrue 7 "$?"
	assertEquals 8 "Gedaan: Test" "$RESULT"

	isSkipping && endSkipping

	# gettext unavailable
	is_available() { return 1; }
	RESULT="$(translate "Something unknown went terribly wrong...")"
	assertTrue 9 "$?"
	assertEquals 10 "Something unknown went terribly wrong..." "$RESULT"

	RESULT="$(translate 'Done: $_display_task')"
	assertTrue 11 "$?"
	assertEquals 12 "Done: Test" "$RESULT"
}

test_escape() {
	RESULT=$(escape 'test "')
	assertEquals 'test \"' "$RESULT"
}
