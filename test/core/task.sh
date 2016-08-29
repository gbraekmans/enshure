
test_task_has_valid_name() {
	__query_current_task() {
		printf ""
	}
	__task_has_valid_name ""
	assertFalse 11 "$?"
	__task_has_valid_name "webserver"
	assertTrue 1 "$?"
	__task_has_valid_name "webserver::mysql"
	assertFalse 2 "$?"
	__task_has_valid_name "testing"
	assertTrue 3 "$?"
	
	__query_current_task() {
		printf "webserver"
	}
	__task_has_valid_name "webserver"
	assertFalse 4 "$?"
	__task_has_valid_name "webserver::mysql"
	assertTrue 5 "$?"
	__task_has_valid_name "testing"
	assertFalse 6 "$?"

	__query_current_task() {
		printf "webserver::mysql"
	}
	__task_has_valid_name "webserver::mysql"
	assertFalse 7 "$?"
	__task_has_valid_name "webserver::mysql::my.cnf"
	assertTrue 8 "$?"
	__task_has_valid_name "webserver::testing"
	assertFalse 9 "$?"

	__task_has_valid_name "webserver::mysql::"
	assertFalse 10 "$?"
}

test_task_is_nested() {
	__task_is_nested "webserver"
	assertFalse 1 "$?"

	__task_is_nested "webserver::mysql"
	assertTrue 2 "$?"
}

test_task_begin() {
	__query_current_task() { printf ""; }
	RESULT=$(__task_begin)
	assertFalse 1 "$?"
	assertEquals 2 "ERROR: '' is not a valid name for a task." "$RESULT"

	RESULT=$(__task_begin "webserver")
	assertTrue 3 "$?"
	assertEquals 4 "Task: webserver" "$(printf '%s' "$RESULT" | head -n1)"
	assertEquals 5 "#BEGIN|1970-01-01 00:00:00|0||||webserver" "$(tail -n1 "$ENSHURE_LOG")"

	__query_current_task() { printf "webserver"; }
	RESULT=$(__task_begin "dbserver")
	assertFalse 6 "$?"
	assertEquals 7 "ERROR: 'dbserver' is not a valid name for a task. Current task is 'webserver'" "$(printf '%s' "$RESULT" | head -n1)"

	RESULT=$(__task_begin "webserver::mysql")
	assertTrue 8 "$?"
	assertEquals 9 "INFO: Subtask: webserver::mysql" "$(printf '%s' "$RESULT" | head -n1)"
	assertEquals 10 "#BEGIN|1970-01-01 00:00:00|0||||webserver::mysql" "$(tail -n1 "$ENSHURE_LOG")"

	__query_current_task() { printf "webserver::mysql"; }
	RESULT=$(__task_begin "webserver::apache")
	assertFalse 11 "$?"
	assertEquals 12 "ERROR: 'webserver::apache' is not a valid name for a task. Current task is 'webserver::mysql'" "$(printf '%s' "$RESULT" | head -n1)"
	
	if ! command -v tput > /dev/null; then
		startSkipping
	fi
	
	__msg_pretty_print() { return 0; }
	isSkipping || RESULT=$(__task_begin "webserver::mysql::my.cnf")
	assertTrue 13 "$?"
	printf '%s' "$RESULT" | grep 'ℹ Subtask: webserver → mysql → my.cnf' > /dev/null
	assertTrue 14 "$?"

	isSkipping && endSkipping
}

test_task_end() {
	__query_current_task() { printf ""; }
	RESULT=$(__task_end)
	assertFalse 1 "$?"
	assertEquals 2 "ERROR: Not in a task right now" "$RESULT"

	__query_current_task() { printf "webserver"; }
	RESULT=$(__task_end)
	assertTrue 3 "$?"
	assertEquals 4 "Done: webserver" "$(printf '%s' "$RESULT" | head -n1)"
	assertEquals 5 "#END|1970-01-01 00:00:00|0||||" "$(tail -n1 "$ENSHURE_LOG")"

	if ! command -v tput > /dev/null; then
		startSkipping
	fi

	__query_current_task() { printf "webserver::mysql"; }
	__msg_pretty_print() { return 0; }
	isSkipping || RESULT=$(__task_end)
	assertTrue 6 "$?"
	printf '%s' "$RESULT" | grep 'ℹ Done: webserver → mysql' > /dev/null
	assertTrue 7 "$?"

	isSkipping && endSkipping
}
