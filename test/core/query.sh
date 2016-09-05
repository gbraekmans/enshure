
test_query() {
	__query_current_task() { printf "current task"; return 0; }
	__query_made_change() { printf "made change"; return 0; }
	__query_summary() { printf "summary - %s" "$1"; return 0; }
	__query_command_output() { printf "command output"; return 0; }

	RESULT=$(query)
	assertFalse 1 "$?"
	assertEquals 2 "ERROR: No query specified. Use -h to get a list of all queries." "$RESULT"

	RESULT=$(query whatever)
	assertFalse 3 "$?"
	assertEquals 4 "ERROR: Argument --query 'whatever' is invalid. Use -h to get a list of all queries." "$RESULT"

	RESULT=$(query current_task)
	assertTrue 5 "$?"
	assertEquals 6 "current task" "$RESULT"

	RESULT=$(query summary)
	assertTrue 7 "$?"
	assertEquals 8 "summary - " "$RESULT"

	RESULT=$(query summary test::task)
	assertTrue 9 "$?"
	assertEquals 10 "summary - test::task" "$RESULT"

	RESULT=$(query made_change)
	assertTrue 11 "$?"
	assertEquals 12 "made change" "$RESULT"

	RESULT=$(query command_output)
	assertTrue 13 "$?"
	assertEquals 14 "command output" "$RESULT"
}

test_query_current_task() {
	RESULT=$(__query_current_task)
	assertTrue 1 "$?"
	assertEquals 2 "" "$RESULT"

	__task_begin "webserver" > /dev/null
	RESULT=$(__query_current_task)
	assertTrue 3 "$?"
	assertEquals 4 "webserver" "$RESULT"

	__task_begin "webserver::apache" > /dev/null
	RESULT=$(__query_current_task)
	assertTrue 5 "$?"
	assertEquals 6 "webserver::apache" "$RESULT"

	__task_end > /dev/null
	RESULT=$(__query_current_task)
	assertTrue 7 "$?"
	assertEquals 8 "webserver" "$RESULT"

	__task_begin "webserver::mysql" > /dev/null
	RESULT=$(__query_current_task)
	assertTrue 9 "$?"
	assertEquals 10 "webserver::mysql" "$RESULT"

	__task_end > /dev/null
	RESULT=$(__query_current_task)
	assertTrue 11 "$?"
	assertEquals 12 "webserver" "$RESULT"

	__task_end > /dev/null
	RESULT=$(__query_current_task)
	assertTrue 13 "$?"
	assertEquals 14 "" "$RESULT"
}

# shellcheck disable=SC2034
test_query_made_change() {
	_STATE='present'
	_MODULE='file'
	_IDENTIFIER='/root/.zshrc'

	__query_made_change
	assertEquals 1 "2" "$?"

	__log_ok > /dev/null
	__query_made_change
	assertEquals 2 "1" "$?"

	__log_change  > /dev/null
	__query_made_change
	assertEquals 3 "0" "$?"
	
	info "test" > /dev/null
	__query_made_change
	assertEquals 4 "0" "$?"	

	error "test" > /dev/null
	__query_made_change
	assertEquals 5 "2" "$?"

	__log_change  > /dev/null
	__query_made_change
	assertEquals 6 "0" "$?"

	__log_ok > /dev/null
	__query_made_change
	assertEquals 7 "1" "$?"
}

# shellcheck disable=SC2034
test_query_summary() {

	_STATE='present'
	_MODULE='file'
	_IDENTIFIER='/root/.zshrc'

	RESULT=$(__query_summary)
	assertTrue 1 "$?"
	assertEquals 2 "$(printf "change: 0\nok: 0\ntotal: 0\n" )" "$RESULT"

	__log_ok > /dev/null
	RESULT=$(__query_summary)
	assertTrue 3 "$?"
	assertEquals 4 "$(printf "change: 0\nok: 1\ntotal: 1\n" )" "$RESULT"

	__log_change > /dev/null
	RESULT=$(__query_summary)
	assertTrue 5 "$?"
	assertEquals 6 "$(printf "change: 1\nok: 1\ntotal: 2\n" )" "$RESULT"

	RESULT=$(__query_summary "testing")
	assertTrue 7 "$?"
	assertEquals 8 "$(printf "change: 0\nok: 0\ntotal: 0\n" )" "$RESULT"

	__task_begin "webserver" > /dev/null
	RESULT=$(__query_summary "webserver")
	assertTrue 9 "$?"
	assertEquals 10 "$(printf "change: 0\nok: 0\ntotal: 0\n" )" "$RESULT"

	__task_begin "webserver::apache" > /dev/null
	RESULT=$(__query_summary "webserver")
	assertTrue 10 "$?"
	assertEquals 11 "$(printf "change: 0\nok: 0\ntotal: 0\n" )" "$RESULT"

	__log_change > /dev/null
	RESULT=$(__query_summary "webserver")
	assertTrue 12 "$?"
	assertEquals 13 "$(printf "change: 1\nok: 0\ntotal: 1\n" )" "$RESULT"

	RESULT=$(__query_summary "webserver::apache")
	assertTrue 13 "$?"
	assertEquals 14 "$(printf "change: 1\nok: 0\ntotal: 1\n" )" "$RESULT"

	RESULT=$(__query_summary "apache")
	assertTrue 15 "$?"
	assertEquals 16 "$(printf "change: 0\nok: 0\ntotal: 0\n" )" "$RESULT"

	RESULT=$(__query_summary)
	assertTrue 17 "$?"
	assertEquals 18 "$(printf "change: 2\nok: 1\ntotal: 3\n" )" "$RESULT"

	__task_end > /dev/null
	RESULT=$(__query_summary "webserver")
	assertTrue 19 "$?"
	assertEquals 20 "$(printf "change: 1\nok: 0\ntotal: 1\n" )" "$RESULT"

	__log_ok > /dev/null
	RESULT=$(__query_summary "webserver")
	assertTrue 21 "$?"
	assertEquals 22 "$(printf "change: 1\nok: 1\ntotal: 2\n" )" "$RESULT"
	
	RESULT=$(__query_summary "webserver::apache")
	assertTrue 23 "$?"
	assertEquals 24 "$(printf "change: 1\nok: 0\ntotal: 1\n" )" "$RESULT"

	__task_begin "webserver::mysql" > /dev/null
	__log_ok > /dev/null

	RESULT=$(__query_summary "webserver")
	assertTrue 25 "$?"
	assertEquals 26 "$(printf "change: 1\nok: 2\ntotal: 3\n" )" "$RESULT"

	RESULT=$(__query_summary)
	assertTrue 27 "$?"
	assertEquals 28 "$(printf "change: 2\nok: 3\ntotal: 5\n" )" "$RESULT"

	RESULT=$(__query_summary "webserver::mysql")
	assertTrue 29 "$?"
	assertEquals 30 "$(printf "change: 0\nok: 1\ntotal: 1\n" )" "$RESULT"

	__task_end > /dev/null
	__task_end > /dev/null

	__log_change > /dev/null

	RESULT=$(__query_summary)
	assertTrue 31 "$?"
	assertEquals 32 "$(printf "change: 3\nok: 3\ntotal: 6\n" )" "$RESULT"

	RESULT=$(__query_summary "webserver")
	assertTrue 33 "$?"
	assertEquals 34 "$(printf "change: 1\nok: 2\ntotal: 3\n" )" "$RESULT"	
}

test_query_command_output() {
	run 'printf "test\n"'
	run 'false'
	info "filler" > /dev/null
	run 'printf "An error!\n" && exit 4 >&2'

	OUTPUT=$(cat <<-EOF
	$ printf "test\n"
	test
	$ false
	# Returned: 1
	$ printf "An error!\n" && exit 4 >&2
	An error!
	# Returned: 4
	EOF
	)

	RESULT=$(__query_command_output)
	assertTrue 1 "$?"
	assertEquals 2 "$OUTPUT" "$RESULT"
}
