test_main_is_query_mode() {
	# First arugmunt has - as start -> true
	__main_is_query_mode --help
	assertTrue 1 "$?"
	# First argument is not - -> false
	__main_is_query_mode rpm_package bash installed
	assertFalse 2 "$?"
}

test_main_query_mode_parse() {
	assertEquals 1 "$_VERSION" "$(__main_query_mode_parse -v)"
	assertEquals 2 "$(__main_query_mode_parse -v)" "$(__main_query_mode_parse --version)"
	
	assertTrue 3 "__main_query_mode_parse -h | head -n 1 | grep ^Usage:"
	assertEquals 4 "$(__main_query_mode_parse -h)" "$(__main_query_mode_parse --help)"
	
	__main_query_task() { printf 'Executed'; }
	assertEquals 5 "Executed" "$(__main_query_mode_parse -t)"
	assertEquals 6 "$(__main_query_mode_parse -t)" "$(__main_query_mode_parse --task)"

	assertEquals 7 "ERROR: Unknown argument '--no-such-option'." "$(__main_query_mode_parse --no-such-option)"

	assertEquals 8 "ERROR: No query specified. Use -h to get a list of all queries." "$(__main_query_mode_parse -q)"
	assertEquals 9 "$(__main_query_mode_parse -q)" "$(__main_query_mode_parse --query)"

	assertEquals 10 "ERROR: Unknown argument '-e'." "$(__main_query_mode_parse -e)"
}

test_main_execute() {
	RESULT=$(__main_execute 2>&1)
	assertFalse 1 "$?"
	assertEquals 2 "CRITICAL FAILURE: No arguments given. Use --help or -h for help." "$RESULT"

	RESULT=$(__main_execute -v)
	assertTrue 3 "$?"
	assertEquals 4 "$_VERSION" "$RESULT"
}

test_main_query_task() {
	RESULT=$(__main_query_task)
	assertFalse 1 "$?"
	assertEquals 2 "ERROR: No task specified. Add 'begin' or 'end'." "$RESULT"

	RESULT=$(__main_query_task whatever)
	assertFalse 3 "$?"
	assertEquals 4 "ERROR: Argument --task 'whatever' is invalid: must be 'begin' or 'end'." "$RESULT"

	__task_end() { return 0; }
	RESULT=$(__main_query_task end)
	assertTrue 5 "$?"
	assertEquals 6 "" "$RESULT"

	__task_begin() { return 0; }
	RESULT=$(__main_query_task begin)
	assertFalse 7 "$?"
	assertEquals 8 "ERROR: No name for the task specified." "$RESULT"

	RESULT=$(__main_query_task begin webserver)
	assertTrue 9 "$?"
	assertEquals 10 "" "$RESULT"

	RESULT=$(__main_query_task end webserver)
	assertFalse 11 "$?"
	assertEquals 12 "ERROR: A name for an ending task is given. This is not supported." "$RESULT"
}
