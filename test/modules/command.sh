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

	assertEquals 5 "3" $(grep '^#CHANGE|' $ENSHURE_LOG | wc -l)
	assertEquals 6 "1" $(grep '^#OK|' $ENSHURE_LOG | wc -l)
	assertEquals 7 "2" $(grep '^#STDOUT|' $ENSHURE_LOG | wc -l)
	assertEquals 8 "1" $(grep '^#RETURN|' $ENSHURE_LOG | wc -l)
	assertEquals 9 "2" $(grep '^echo ' $ENSHURE_LOG | wc -l)
	
	enshure -q command_output | grep -q '^test'
	assertTrue 10  "$?"
	enshure -q command_output | grep -q '^quoted test'
	assertTrue 11  "$?"

	rm -rf "$TMP"
}
