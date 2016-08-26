test_help() {
	assertEquals 1 "Usage: enshure QUERY_MODE [ARGUMENT] ..." "$(__help | head -n 1)"
}
