
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
