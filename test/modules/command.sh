test_command() {
	enshure command 'echo test'
	assertTrue "$?"
	enshure command "echo \"quoted test\""
	#~ cat $ENSHURE_LOG
	enshure -q command_output
}
