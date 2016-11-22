test_module_type() {
	module_type command
	assertTrue 1 "$?"
	assertEquals 2 "command" "$_MODULE_TYPE"

	_MODULE_TYPE=''
	RESULT=$(module_type whatever 2>&1)
	assertFalse 3 "$?"
	assertEquals 4 "CRITICAL FAILURE: No such module-type: 'whatever'" "$RESULT"
}

test_module_description() {
	module_description test
	assertTrue 1 "$?"
	assertEquals 2 "test" "$_MODULE_DESCRIPTION"
}

# shellcheck disable=SC2034
test_module_is_valid_state() {
	_STATES="yes:no"

	__module_is_valid_state "yes"
	assertTrue 1 "$?"

	__module_is_valid_state "no"
	assertTrue 2 "$?"

	__module_is_valid_state "whatever"
	assertFalse 3 "$?"

	_STATE=yes
	__module_is_valid_state
	assertTrue 4 "$?"

	_STATE=whatever
	__module_is_valid_state
	assertFalse 5 "$?"
}

# shellcheck disable=SC2034
test_module_load() {
	TMP=$(mktemp -d)

	touch "$TMP/test.sh"
	mkdir "$TMP/testing"
	touch "$TMP/testing/main.sh"

	ENSHURE_MODULE_PATH="$TMP"

	__module_load "test"
	assertTrue 1 "$?"

	__module_load "testing"
	assertTrue 2 "$?"

	RESULT=$(__module_load "whatever" 2>&1)
	assertFalse 3 "$?"
	assertEquals 4 "ERROR: Could not locate module 'whatever'" "$RESULT"

	unset ENSHURE_MODULE_PATH

	rm -rf "$TMP"
}

# shellcheck disable=SC2034
test_module_list() {
	TMP=$(mktemp -d)

	touch "$TMP/test.sh"
	mkdir "$TMP/testing"
	touch "$TMP/testing/main.sh"

	ENSHURE_MODULE_PATH="$TMP"

	RESULT=$(__module_list 2>&1 | sort)
	assertTrue 1 "$?"
	assertEquals 2 "test-testing" "$(printf '%s' "$RESULT" | tr '\n' '-')"

	unset ENSHURE_MODULE_PATH

	rm -rf "$TMP"
}

test_argument() {
	RESULT=$(argument name 2>&1)
	assertFalse 1 "$?"
	assertEquals 2 "CRITICAL FAILURE: Can't add an argument before a module type is loaded" "$RESULT"

	_MODULE_TYPE=command

	RESULT=$(argument name 2>&1)
	assertFalse 3 "$?"

	RESULT=$(argument name whatever optional 2>&1)
	assertFalse 4 "$?"
	assertEquals 5 "ERROR: Argument has an invalid type for it's value: 'whatever'." "$RESULT"

	RESULT=$(argument name string whatever 2>&1)
	assertFalse 6 "$?"
	assertEquals 7 "ERROR: Argument has an invalid type: 'whatever'." "$RESULT"

	RESULT="$(argument name "enum(" optional 2>&1)"
	assertFalse 8 "$?"
	assertEquals 9 "ERROR: The enum 'enum(' is of the wrong format." "$RESULT"

	argument name string optional help example
	assertTrue 10 "$?"

	# Overwrite the argument
	argument name string optional help example default
	assertTrue 11 "$?"
	assertEquals 12 "name|string|optional|help|example|default" "$_ARGUMENTS"

	argument name string identifier help example default
	assertTrue 12 "$?"
	argument name string identifier help example defaulttest
	assertTrue 13 "$?"
	assertEquals 14 "name|string|identifier|help|example|defaulttest" "$_ARGUMENTS"

	argument name2 string optional help example
	assertTrue 15 "$?"

	RESULT="$(argument name3 string identifier help example 2>&1)"
	assertFalse 16 "$?"
	assertEquals 17 "ERROR: Argument identifier already defined." "$RESULT"

	argument id string identifier "" "" > /dev/null 2>&1
	assertFalse 18 "$?"

	RESULT=$(argument id integer optional "" "" "seven" 2>&1)
	assertFalse 19 "$?"
	assertEquals 20 "ERROR: The value 'seven' is not of type 'integer'." "$RESULT"

	unset _ARGUMENTS
}

# shellcheck disable=SC2034,SC2154
test_module_parse() {
	_IDENTIFIER=test
	_MODULE=testing

	RESULT=$(__module_parse 2>&1)
	assertFalse 1 "$?"
	assertEquals 2 "ERROR: Module 'testing' does not define an identifier." "$RESULT"

	argument id string identifier "" ""
	argument num integer required "" ""
	argument str string optional "" ""

	__module_parse num 1337
	assertTrue 3 "$?"
	assertEquals 4 "1337" "$num"
	assertEquals 4 "test" "$id"

	RESULT=$(__module_parse testing test 2>&1)
	assertFalse 5 "$?"
	assertEquals 6 "ERROR: No such argument: 'testing'" "$RESULT"

	RESULT=$(__module_parse 2>&1)
	assertFalse 6 "$?"
	assertEquals 7 "ERROR: The argument 'num' is required, but not given." "$RESULT"

	RESULT=$(__module_parse id whatever num 3 2>&1)
	assertTrue 8 "$?"
	assertEquals 9 "test" "$id"

	RESULT=$(__module_parse num 3 2>&1)
	assertEquals 14 "test" "$id"

	__module_parse str "a quoted test" num 3
	assertEquals 15 "a quoted test" "$str"

	__module_is_valid_type() { return 1; }
	RESULT=$(__module_parse num 3 2>&1)
	assertFalse 10 "$?"
	assertEquals 11 "ERROR: The value 'test' is not of type 'string'." "$RESULT"

	__module_is_valid_type() { if [ "$1" = "string" ]; then return 0; fi; return 1; }
	RESULT=$(__module_parse num 3 2>&1)
	assertFalse 12 "$?"
	assertEquals 13 "ERROR: The value '3' is not of type 'integer'." "$RESULT"

	unset _ARGUMENTS
	unset _IDENTIFIER
	unset _MODULE
}

test_module_is_valid_type() {
	__module_is_valid_type string "this"
	assertTrue 1 "$?"

	__module_is_valid_type boolean ""
	assertTrue 2 "$?"

	__module_is_valid_type whatever ""
	assertTrue 3 "$?"

	__module_is_valid_type whatever "x"
	assertFalse 4 "$?"

	__module_is_valid_type integer 459480223342
	assertTrue 5 "$?"

	__module_is_valid_type integer 3.1415
	assertFalse 6 "$?"

	__module_is_valid_type float 3.1415
	assertTrue 7 "$?"

	__module_is_valid_type float 3,1415
	assertFalse 8 "$?"

	__module_is_valid_type boolean "yes"
	assertTrue 9 "$?"

	__module_is_valid_type boolean "no"
	assertTrue 10 "$?"

	__module_is_valid_type boolean "true"
	assertFalse 11 "$?"

	__module_is_valid_type "enum(true:false)" "true"
	assertTrue 12 "$?"

	__module_is_valid_type "enum(this)" "this"
	assertTrue 13 "$?"

	__module_is_valid_type "enum(this:that)" "what"
	assertFalse 14 "$?"
}

# shellcheck disable=SC2034
test_module_translated_state() {
	_STATES="present:absent"
	_TRANSLATED_STATES="tpresent:tabsent"
	_STATE="test"

	RESULT=$(translated_state "present")
	assertTrue 1 "$?"
	assertEquals 2 "tpresent" "$RESULT"

	RESULT=$(translated_state)
	assertTrue 3 "$?"
	assertEquals 4 "test" "$RESULT"

	RESULT=$(translated_state "absent")
	assertTrue 5 "$?"
	assertEquals 6 "tabsent" "$RESULT"

	unset _STATES
	unset _TRANSLATED_STATES
}
