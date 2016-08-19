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
	ENSHURE_LOG="-"
	assertEquals 2 "#INFO|$(date '+%Y-%m-%d %H:%M:%S')|RPM_PACKAGE|bash|installed|Will not refresh metadata." "$(__log_entry 'INFO' 'Will not refresh metadata.')"
}

oneTimeSetUp() {
	export _BASEDIR="$ENSHURE_SRC"
	. "$ENSHURE_SRC/core/log.sh"
}
