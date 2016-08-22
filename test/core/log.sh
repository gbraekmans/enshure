test_log_should_write_stdout() {
	# ENSHURE_LOG is - -> true
	ENSHURE_LOG="-" __log_should_write_to_stdout
	assertTrue 1 "$?"
	# ENSHURE_LOG is not - -> false
	ENSHURE_LOG= __log_should_write_to_stdout
	assertFalse 2 "$?"
}

test_log_date() {
	assertEquals "$(date '+%Y-%m-%d %H:%M:%S')" "$(__log_date)"
}

test_log_entry() {
	_MODULE=
	_IDENTIFIER=
	_REQUESTED_STATE=
	ENSHURE_LOG="-"
	assertEquals 1 "#WARNING|$(date '+%Y-%m-%d %H:%M:%S')||||Will not refresh metadata." "$(__log_entry 'WARNING' 'Will not refresh metadata.')"
	_MODULE=RPM_PACKAGE
	_IDENTIFIER=bash
	_REQUESTED_STATE=installed
	assertEquals 2 "#INFO|$(date '+%Y-%m-%d %H:%M:%S')|RPM_PACKAGE|bash|installed|Will not refresh metadata." "$(__log_entry 'INFO' 'Will not refresh metadata.')"
	TMP=$(mktemp)
	chmod 444 "$TMP"
	ENSHURE_LOG="$TMP"
	assertEquals 3 "CRITICAL FAILURE: Could not write to log file '$TMP'." "$(__log_entry 'INFO' 'Will not refresh metadata.' 2>&1)"
	chmod 666 "$TMP"
	__log_entry 'INFO' 'Will not refresh metadata.'
	assertEquals 4 "#INFO|$(date '+%Y-%m-%d %H:%M:%S')|RPM_PACKAGE|bash|installed|Will not refresh metadata." "$(cat "$TMP")"
	rm -rf "$TMP"
}

oneTimeSetUp() {
	. "$_BASEDIR/core/base.sh"
	include core/log
}
