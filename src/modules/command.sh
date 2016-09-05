
module_type command
module_description "$(translate "Executes a command.")"

argument statement string identifier "$(translate "the statement to be executed")" "touch $HOME/test"
argument creates_file string optional "$(translate "the path to a file, link or directory created by the command")" "$HOME/test"

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
