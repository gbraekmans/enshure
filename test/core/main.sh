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

	RESULT=$(__main_execute whatever 2>&1)
	assertFalse 3 "$?"
	assertEquals 4 "ERROR: A module and identifier must be specified." "$RESULT"
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

# shellcheck disable=SC2034
test_main_execute_mode_parse_state() {
	_DEFAULT_STATE="default"
	
	RESULT=$(__main_execute_mode_parse_state mod id)
	assertTrue 1 "$?"
	assertEquals 2 "default" "$RESULT"

	RESULT=$(__main_execute_mode_parse_state mod id test)
	assertTrue 3 "$?"
	assertEquals 4 "test" "$RESULT"

	RESULT=$(__main_execute_mode_parse_state mod id arg val)
	assertTrue 5 "$?"
	assertEquals 6 "default" "$RESULT"

	RESULT=$(__main_execute_mode_parse_state mod id test arg val)
	assertTrue 7 "$?"
	assertEquals 8 "test" "$RESULT"

	RESULT=$(__main_execute_mode_parse_state mod "id test")
	assertTrue 9 "$?"
	assertEquals 10 "default" "$RESULT"
}

# shellcheck disable=SC2034
test_main_execute_mode_parse() {
	# Stub out almost everything ;)
	__module_load() { _MODULE="$1"; }
	__module_is_valid_state() { return 0; }
	is_state() { return 0; }
	attain_state() { return 0; }
	__module_parse() { return 0; }
	__log_ok() { printf 'OK'; }
	__log_change() { printf 'CHANGE'; }
	verify_requirements() { return 0; }

	_DEFAULT_STATE='state'

	__main_execute_mode_parse test this > /dev/null 2>&1
	assertTrue 1 "$?"
	assertEquals 2 "this" "$_IDENTIFIER"

	__main_execute_mode_parse test thiss state > /dev/null 2>&1
	assertTrue 3 "$?"
	assertEquals 4 "thiss" "$_IDENTIFIER"

	__main_execute_mode_parse test "thiss states" > /dev/null 2>&1
	assertTrue 12 "$?"
	assertEquals 13 "thiss states" "$_IDENTIFIER"
	assertEquals 14 "state" "$_STATE"

	__module_is_valid_state() { return 1; }
	RESULT=$(__main_execute_mode_parse test thiss state 2>&1)
	assertFalse 5 "$?"
	assertEquals 6 "ERROR: 'state' is not a valid state for module 'test'." "$RESULT"
	__module_is_valid_state() { return 0; }

	is_state() { return 1; }
	RESULT=$(__main_execute_mode_parse test this state 2>&1)
	assertTrue 7 "$?"

	verify_requirements() { return 1; }
	RESULT=$(__main_execute_mode_parse test this state 2>&1)
	assertFalse 8 "$?"
	assertEquals 9 "ERROR: Not all requirements are met." "$RESULT"

	verify_requirements() { return 0; }
	ENSHURE_VALIDATE=yes
	RESULT=$(__main_execute_mode_parse test this state 2>&1)
	assertTrue 10 "$?"
	assertEquals 11 "" "$RESULT"
}
