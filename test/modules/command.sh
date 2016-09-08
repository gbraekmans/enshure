test_command() {
	RESULT=$(enshure -v)
	assertEquals "" "$RESULT"
	
	enshure command 'echo test'
	cat "$ENSHURE_LOG"
}
