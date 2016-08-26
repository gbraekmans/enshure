test_log_should_write_stdout() {
	# ENSHURE_LOG is - -> true
	ENSHURE_LOG="-" __log_should_write_to_stdout
	assertTrue 1 "$?"
	# ENSHURE_LOG is not - -> false
	ENSHURE_LOG='' __log_should_write_to_stdout
	assertFalse 2 "$?"
}

test_log_date() {
	assertEquals "$(date '+%Y-%m-%d %H:%M:%S')" "$(__log_date)"
}

# shellcheck disable=SC2034
test_log_path() {
	ENSHURE_LOG="/tmp/test.log"
	RESULT=$(__log_path)
	assertTrue 1 "$?"
	assertEquals 2 "/tmp/test.log" "$RESULT"

	ENSHURE_LOG=""
	RESULT=$(__log_path)
	assertTrue 3 "$?"
	assertEquals 4 "/var/log/enshure.log" "$RESULT"
}

# shellcheck disable=SC2034
test_log_entry() {
	_MODULE=
	_IDENTIFIER=
	_REQUESTED_STATE=
	ENSHURE_LOG="-"
	assertEquals 1 "#WARNING|1970-01-01 00:00:00|0||||Will not refresh metadata." "$(__log_entry 'WARNING' 'Will not refresh metadata.')"
	_MODULE=RPM_PACKAGE
	_IDENTIFIER=bash
	_REQUESTED_STATE=installed
	assertEquals 2 "#INFO|1970-01-01 00:00:00|0|RPM_PACKAGE|bash|installed|Will not refresh metadata." "$(__log_entry 'INFO' 'Will not refresh metadata.')"
	TMP=$(mktemp)
	chmod 444 "$TMP"
	ENSHURE_LOG="$TMP"
	assertEquals 3 "CRITICAL FAILURE: Could not write to log file '$TMP'." "$(__log_entry 'INFO' 'Will not refresh metadata.' 2>&1)"
	chmod 666 "$TMP"
	__log_entry 'INFO' 'Will not refresh metadata.'
	assertEquals 4 "#INFO|1970-01-01 00:00:00|0|RPM_PACKAGE|bash|installed|Will not refresh metadata." "$(cat "$TMP")"
	rm -rf "$TMP"
}

# shellcheck disable=SC2034
test_log_can_write_module_functions() {
	_ACTUAL_STATE=''
	_REQUESTED_STATE=''
	_MODULE=''
	_IDENTIFIER=''
	__log_can_write_module_functions
	assertFalse 1 "$?"

	_REQUESTED_STATE='present'
	_MODULE='file'
	_IDENTIFIER='/root/.zshrc'
	__log_can_write_module_functions
	assertFalse 2 "$?"

	_ACTUAL_STATE='absent'
	__log_can_write_module_functions
	assertTrue 3 "$?"
}

# shellcheck disable=SC2034
test_log_change() {
	_ACTUAL_STATE=''
	_REQUESTED_STATE=''
	_MODULE=''
	_IDENTIFIER=''
	RESULT=$(__log_change 2>&1)
	assertFalse 1 "$?"
	assertEquals 2 "CRITICAL FAILURE: Can not signal CHANGE when no module is loaded." "$RESULT"

	_REQUESTED_STATE='present'
	_MODULE='file'
	_IDENTIFIER='/root/.zshrc'
	RESULT=$(__log_change 2>&1)
	assertFalse 3 "$?"
	assertEquals 4 "CRITICAL FAILURE: Can not signal CHANGE when no module is loaded." "$RESULT"

	_ACTUAL_STATE='absent'
	RESULT=$(__log_change 2>&1)
	assertTrue 5 "$?"
	assertEquals 6 "CHANGE: File /root/.zshrc is present, was absent." "$RESULT"
	assertEquals 7 "#CHANGE|1970-01-01 00:00:00|0|file|/root/.zshrc|present|File /root/.zshrc is present, was absent." "$(tail -n1 "$ENSHURE_LOG")"
}

# shellcheck disable=SC2034
test_log_ok() {
	_ACTUAL_STATE=''
	_REQUESTED_STATE=''
	_MODULE=''
	_IDENTIFIER=''
	RESULT=$(__log_ok 2>&1)
	assertFalse 1 "$?"
	assertEquals 2 "CRITICAL FAILURE: Can not signal OK when no module is loaded." "$RESULT"

	_REQUESTED_STATE='present'
	_MODULE='file'
	_IDENTIFIER='/root/.zshrc'
	RESULT=$(__log_ok 2>&1)
	assertFalse 3 "$?"
	assertEquals 4 "CRITICAL FAILURE: Can not signal OK when no module is loaded." "$RESULT"

	_ACTUAL_STATE='absent'
	RESULT=$(__log_ok 2>&1)
	assertTrue 5 "$?"
	assertEquals 6 "OK: File /root/.zshrc is present." "$RESULT"
	assertEquals 7 "#OK|1970-01-01 00:00:00|0|file|/root/.zshrc|present|File /root/.zshrc is present." "$(tail -n1 "$ENSHURE_LOG")"
}
