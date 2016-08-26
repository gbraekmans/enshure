
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
