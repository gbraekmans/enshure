test_log_should_write_stdout() {
	# ENSHURE_LOG is - -> true
	ENSHURE_LOG="-" __log_should_write_to_stdout
	assertTrue "$?"
	# ENSHURE_LOG is not - -> false
	ENSHURE_LOG= __log_should_write_to_stdout
	assertFalse "$?"
}

test_log_date() {
	assertEquals "$(date '+%Y-%m-%d %H:%M:%S')" "$(__log_date)"
}

test_log_entry() {
	_MODULE=RPM_PACKAGE
	_IDENTIFIER=bash
	_REQUESTED_STATE=installed
	ENSHURE_LOG="-"
	assertEquals "#INFO|$(date '+%Y-%m-%d %H:%M:%S')|RPM_PACKAGE|bash|installed|Will not refresh metadata." "$(__log_entry 'INFO' 'Will not refresh metadata.')"
}

oneTimeSetUp() {
	export _BASEDIR="$ENSHURE_SRC"
	. "$ENSHURE_SRC/core/log.sh"
}
