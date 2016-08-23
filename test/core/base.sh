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
	assertEquals 3 "#ERROR|$(__log_date)||||test" "$(cat "$ENSHURE_LOG")"
}

test_warning() {
	RESULT=$(warning "test")
	assertTrue 1 "$?"
	assertEquals 2 "WARNING: test" "$RESULT"
	assertEquals 3 "#WARNING|$(__log_date)||||test" "$(cat "$ENSHURE_LOG")"
}

test_info() {
	RESULT=$(info "test")
	assertTrue 1 "$?"
	assertEquals 2 "INFO: test" "$RESULT"
	assertEquals 3 "#INFO|$(__log_date)||||test" "$(cat "$ENSHURE_LOG")"
}

test_debug() {
	# Loglevel DEBUG, should log and print
	ENSHURE_VERBOSITY="DEBUG"
	RESULT=$(debug "test")
	assertTrue 1 "$?"
	assertEquals 2 "DEBUG: test" "$RESULT"
	assertEquals 3 "#DEBUG|$(__log_date)||||test" "$(cat "$ENSHURE_LOG")"
	unset ENSHURE_VERBOSITY
	printf '' > "$ENSHURE_LOG"

	# Loglevel INFO, should log but not print
	RESULT=$(debug "test2")
	assertTrue 4 "$?"
	assertEquals 5 "" "$RESULT"
	assertEquals 6 "#DEBUG|$(__log_date)||||test2" "$(cat "$ENSHURE_LOG")"
}

test_include() {
	# Reset included, don't do this if not testing ;)
	_INCLUDED=
	test -n "$_VERSION"
	assertFalse 1 "$?"
	include core/version
	assertEquals 1 "core/base:core/version" "$_INCLUDED"
	test -n "$_VERSION"
	assertTrue 2 "$?"
	include core/version
	assertEquals 3 "core/base:core/version" "$_INCLUDED"
	include core/error
	assertEquals 4 "core/base:core/version:core/error" "$_INCLUDED"
}

setUp() {
	# Freeze time for logs
	date() {
		if [ '+%Y-%m-%d %H:%M:%S' = "$1" ]; then
			printf '1970-01-01 00:00:00'
		else
			/usr/bin/date "$@"
		fi
	}
	ENSHURE_LOG=$(mktemp)
}

tearDown() {
	rm -rf "$ENSHURE_LOG"
}

oneTimeSetUp() {
	. "$_BASEDIR/core/base.sh"
	include core/log
}