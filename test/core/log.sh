test_log_should_write_stdout() {
	_OLD_LOG=$ENSHURE_LOG

	# ENSHURE_LOG is - -> true
	ENSHURE_LOG="-" __log_should_write_to_stdout
	assertTrue 1 "$?"
	# ENSHURE_LOG is not - -> false
	ENSHURE_LOG='' __log_should_write_to_stdout
	assertFalse 2 "$?"

	ENSHURE_LOG=$_OLD_LOG
}

test_log_date() {
	assertEquals "$(date '+%Y-%m-%d %H:%M:%S')" "$(__log_date)"
}

# shellcheck disable=SC2034
test_log_path() {
	_OLD_LOG=$ENSHURE_LOG


	ENSHURE_LOG="/tmp/test.log"
	RESULT=$(__log_path)
	assertTrue 1 "$?"
	assertEquals 2 "/tmp/test.log" "$RESULT"

	ENSHURE_LOG=""
	RESULT=$(__log_path)
	assertTrue 3 "$?"
	assertEquals 4 "/var/log/enshure.log" "$RESULT"

	ENSHURE_LOG=$_OLD_LOG
}

# shellcheck disable=SC2034
test_log_entry() {
	_MODULE=
	_IDENTIFIER=
	_STATE=
	_OLD_LOG=$ENSHURE_LOG
	ENSHURE_LOG="-"
	assertEquals 1 "#WARNING|1970-01-01 00:00:00|0||||Will not refresh metadata." "$(__log_entry 'WARNING' 'Will not refresh metadata.')"
	_MODULE=RPM_PACKAGE
	_IDENTIFIER=bash
	_STATE=installed
	assertEquals 2 "#INFO|1970-01-01 00:00:00|0|RPM_PACKAGE|bash|installed|Will not refresh metadata." "$(__log_entry 'INFO' 'Will not refresh metadata.')"
	TMP=$(mktemp)
	chmod 444 "$TMP"
	ENSHURE_LOG="$TMP"
	assertEquals 3 "CRITICAL FAILURE: Could not write to log file '$TMP'." "$(__log_entry 'INFO' 'Will not refresh metadata.' 2>&1)"
	rm -rf "$TMP"
	__log_entry 'INFO' 'Will not refresh metadata.'
	assertEquals 4 "#INFO|1970-01-01 00:00:00|0|RPM_PACKAGE|bash|installed|Will not refresh metadata." "$(cat "$TMP")"
	rm -rf "$TMP"
	ENSHURE_LOG=$_OLD_LOG
}

# shellcheck disable=SC2034
test_log_can_write_module_functions() {
	_STATE=''
	_MODULE=''
	_IDENTIFIER=''
	__log_can_write_module_functions
	assertFalse 1 "$?"

	_STATE='present'
	_MODULE='file'
	_IDENTIFIER='/root/.zshrc'
	__log_can_write_module_functions
	assertTrue 2 "$?"

	_STATE='absent'
	__log_can_write_module_functions
	assertTrue 3 "$?"
}

# shellcheck disable=SC2034
test_log_change() {
	_STATE=''
	_MODULE=''
	_IDENTIFIER=''
	RESULT=$(__log_change 2>&1)
	assertFalse 1 "$?"
	assertEquals 2 "CRITICAL FAILURE: Can not signal 'CHANGE' when no module is loaded." "$RESULT"

	_STATE='present'
	_MODULE='file'
	RESULT=$(__log_change 2>&1)
	assertFalse 3 "$?"
	assertEquals 4 "CRITICAL FAILURE: Can not signal 'CHANGE' when no module is loaded." "$RESULT"

	_IDENTIFIER='/root/.zshrc'
	_STATE='absent'
	RESULT=$(__log_change 2>&1)
	assertTrue 5 "$?"
	assertEquals 6 "CHANGE: File /root/.zshrc is now absent." "$RESULT"
	assertEquals 7 "#CHANGE|1970-01-01 00:00:00|0|file|/root/.zshrc|absent|File /root/.zshrc is now absent." "$(tail -n1 "$ENSHURE_LOG")"

	printf '' > "$ENSHURE_LOG"
	_DONT_PRINT_CHANGE="true"
	RESULT=$(__log_change 2>&1)
	assertTrue 8 "$?"
	assertEquals 9 "" "$RESULT"
	assertEquals 10 "#CHANGE|1970-01-01 00:00:00|0|file|/root/.zshrc|absent|File /root/.zshrc is now absent." "$(tail -n1 "$ENSHURE_LOG")"

	printf '' > "$ENSHURE_LOG"
	_DONT_LOG_CHANGE="true"
	RESULT=$(__log_change 2>&1)
	assertTrue 11 "$?"
	assertEquals 12 "" "$RESULT"
	assertEquals 13 "" "$(tail -n1 "$ENSHURE_LOG")"

	unset _DONT_PRINT_CHANGE

	printf '' > "$ENSHURE_LOG"
	RESULT=$(__log_change 2>&1)
	assertTrue 14 "$?"
	assertEquals 15 "CHANGE: File /root/.zshrc is now absent." "$RESULT"
	assertEquals 16 "" "$(tail -n1 "$ENSHURE_LOG")"

	unset _DONT_LOG_CHANGE
}

# shellcheck disable=SC2034
test_log_ok() {
	_STATE=''
	_MODULE=''
	_IDENTIFIER=''
	RESULT=$(__log_ok 2>&1)
	assertFalse 1 "$?"
	assertEquals 2 "CRITICAL FAILURE: Can not signal 'OK' when no module is loaded." "$RESULT"

	_STATE='present'
	_IDENTIFIER='/root/.zshrc'
	RESULT=$(__log_ok 2>&1)
	assertFalse 3 "$?"
	assertEquals 4 "CRITICAL FAILURE: Can not signal 'OK' when no module is loaded." "$RESULT"

	_MODULE='file'
	RESULT=$(__log_ok 2>&1)
	assertTrue 5 "$?"
	assertEquals 6 "OK: File /root/.zshrc is already present." "$RESULT"
	assertEquals 7 "#OK|1970-01-01 00:00:00|0|file|/root/.zshrc|present|File /root/.zshrc is already present." "$(tail -n1 "$ENSHURE_LOG")"

	printf '' > "$ENSHURE_LOG"
	_DONT_PRINT_CHANGE="true"
	RESULT=$(__log_ok 2>&1)
	assertTrue 8 "$?"
	assertEquals 9 "" "$RESULT"
	assertEquals 10 "#OK|1970-01-01 00:00:00|0|file|/root/.zshrc|present|File /root/.zshrc is already present." "$(tail -n1 "$ENSHURE_LOG")"

	printf '' > "$ENSHURE_LOG"
	_DONT_LOG_CHANGE="true"
	RESULT=$(__log_ok 2>&1)
	assertTrue 11 "$?"
	assertEquals 12 "" "$RESULT"
	assertEquals 13 "" "$(tail -n1 "$ENSHURE_LOG")"

	unset _DONT_PRINT_CHANGE

	printf '' > "$ENSHURE_LOG"
	RESULT=$(__log_ok 2>&1)
	assertTrue 14 "$?"
	assertEquals 15 "OK: File /root/.zshrc is already present." "$RESULT"
	assertEquals 16 "" "$(tail -n1 "$ENSHURE_LOG")"

	unset _DONT_LOG_CHANGE
}
