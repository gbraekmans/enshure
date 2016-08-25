
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
