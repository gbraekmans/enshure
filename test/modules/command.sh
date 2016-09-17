test_command() {
	enshure command 'echo test' > /dev/null 2>&1
	assertTrue 1 "$?"

	enshure command "echo \"quoted test\"" > /dev/null 2>&1
	assertTrue 2 "$?"

	TMP=$(mktemp)
	enshure command "echo \"quoted test\"" creates_file "$TMP" > /dev/null 2>&1
	assertTrue 3 "$?"

	enshure command "exit 3" > /dev/null 2>&1
	assertTrue 4 "$?"

	assertEquals 5 "3" "$(grep -c '^#CHANGE|' "$ENSHURE_LOG")"
	assertEquals 6 "1" "$(grep -c '^#OK|' "$ENSHURE_LOG")"
	assertEquals 7 "2" "$(grep -c '^#STDOUT|' "$ENSHURE_LOG")"
	assertEquals 8 "1" "$(grep -c '^#RETURN|' "$ENSHURE_LOG")"
	assertEquals 9 "2" "$(grep -c '^echo ' "$ENSHURE_LOG")"

	enshure -q command_output | grep -q '^test'
	assertTrue 10  "$?"
	enshure -q command_output | grep -q '^quoted test'
	assertTrue 11  "$?"

	rm -rf "$TMP"
}
