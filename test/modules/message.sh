# shellcheck disable=SC2034
test_message() {
	RESULT=$(enshure message 'Hello world!')
	assertTrue 1 "$?"
	assertEquals 2 "INFO: Hello world!" "$RESULT"

	RESULT=$(enshure message 'Hello world!' error)
	assertTrue 3 "$?"
	assertEquals 4 "ERROR: Hello world!" "$RESULT"

	RESULT=$(enshure message 'Hello world!' warning)
	assertTrue 5 "$?"
	assertEquals 6 "WARNING: Hello world!" "$RESULT"

	RESULT=$(enshure message 'Hello world!' debug)
	assertTrue 7 "$?"
	assertEquals 8 "" "$RESULT"

	ENSHURE_VERBOSITY="DEBUG"
	RESULT=$(enshure message 'Hello world!' debug)
	assertTrue 9 "$?"
	assertEquals 10 "DEBUG: Hello world!" "$(printf '%s' "$RESULT" | grep 'Hello')"
}
