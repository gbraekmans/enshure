
module_type command
module_description "$(translate "Executes a TEST.")"

argument statement string identifier "" "\"touch /root/test\""
argument creates_file string optional "" "/root/test"
argument test1 integer required "" "5"
argument test2 float required "" "3.14"
argument test3 boolean required "" "yes"
argument test4 "enum(true:false)" optional "" "false"

is_state_executed() {
	return 0
}

attain_state_executed() {
	return 0
}
