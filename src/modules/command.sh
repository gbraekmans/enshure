
module_type command
module_description "$(translate "Executes a command.")"

argument statement string identifier "$(translate "The statement to be executed.")" "\"touch /root/test\""
argument creates_file string optional "$(translate "The path to a file, link or directory created by the command.")" "/root/test"

# TODO add argument to check log if command ran

is_state_executed() {
	if [ -n "$creates_file" ] && [ -e "$creates_file" ]; then
		return 0
	fi
	return 1
}

attain_state_executed() {
	run "$statement"
	retcode="$?"
	if [ "$retcode" -ne "0" ]; then
		warning "$(translate "The command '\$statement' returned \$retcode.")"
	fi
	return 0
}
