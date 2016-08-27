
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
	_REQUESTED_STATE='present'
	_MODULE='file'
	_IDENTIFIER='/root/.zshrc'
	_ACTUAL_STATE='absent'

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

	_REQUESTED_STATE='present'
	_MODULE='file'
	_IDENTIFIER='/root/.zshrc'
	_ACTUAL_STATE='absent'

	RESULT=$(__query_summary)
	assertTrue 1 "$?"
	assertEquals 2 "Made 0 changes of 0 statements." "$RESULT"

	__log_ok > /dev/null
	RESULT=$(__query_summary)
	assertTrue 3 "$?"
	assertEquals 4 "Made 0 changes of 1 statement." "$RESULT"

	__log_change > /dev/null
	RESULT=$(__query_summary)
	assertTrue 5 "$?"
	assertEquals 6 "Made 1 change of 2 statements." "$RESULT"

	RESULT=$(__query_summary "testing")
	assertTrue 7 "$?"
	assertEquals 8 "Made 0 changes of 0 statements." "$RESULT"

	__task_begin "webserver" > /dev/null
	RESULT=$(__query_summary "webserver")
	assertTrue 9 "$?"
	assertEquals 10 "Made 0 changes of 0 statements." "$RESULT"

	__task_begin "webserver::apache" > /dev/null
	RESULT=$(__query_summary "webserver")
	assertTrue 10 "$?"
	assertEquals 11 "Made 0 changes of 0 statements." "$RESULT"

	__log_change > /dev/null
	RESULT=$(__query_summary "webserver")
	assertTrue 12 "$?"
	assertEquals 13 "Made 1 change of 1 statement." "$RESULT"

	RESULT=$(__query_summary "webserver::apache")
	assertTrue 13 "$?"
	assertEquals 14 "Made 1 change of 1 statement." "$RESULT"

	RESULT=$(__query_summary "apache")
	assertTrue 15 "$?"
	assertEquals 16 "Made 0 changes of 0 statements." "$RESULT"

	RESULT=$(__query_summary)
	assertTrue 17 "$?"
	assertEquals 18 "Made 2 changes of 3 statements." "$RESULT"

	__task_end > /dev/null
	RESULT=$(__query_summary "webserver")
	assertTrue 19 "$?"
	assertEquals 20 "Made 1 change of 1 statement." "$RESULT"

	__log_ok > /dev/null
	RESULT=$(__query_summary "webserver")
	assertTrue 21 "$?"
	assertEquals 22 "Made 1 change of 2 statements." "$RESULT"
	
	RESULT=$(__query_summary "webserver::apache")
	assertTrue 23 "$?"
	assertEquals 24 "Made 1 change of 1 statement." "$RESULT"

	__task_begin "webserver::mysql" > /dev/null
	__log_ok > /dev/null

	RESULT=$(__query_summary "webserver")
	assertTrue 25 "$?"
	assertEquals 26 "Made 1 change of 3 statements." "$RESULT"

	RESULT=$(__query_summary)
	assertTrue 27 "$?"
	assertEquals 28 "Made 2 changes of 5 statements." "$RESULT"

	RESULT=$(__query_summary "webserver::mysql")
	assertTrue 29 "$?"
	assertEquals 30 "Made 0 changes of 1 statement." "$RESULT"

	__task_end > /dev/null
	__task_end > /dev/null

	__log_change > /dev/null

	RESULT=$(__query_summary)
	assertTrue 31 "$?"
	assertEquals 32 "Made 3 changes of 6 statements." "$RESULT"

	RESULT=$(__query_summary "webserver")
	assertTrue 33 "$?"
	assertEquals 34 "Made 1 change of 3 statements." "$RESULT"	
}
