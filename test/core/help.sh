test_help_query_mode() {
	assertEquals 1 "-h [MODULE], --help [MODULE]:" "$(__help_query_mode | head -n 1)"
	assertEquals 2 "	If MODULE is empty, show a help message and exit. Otherwise show" "$(__help_query_mode | head -n 2| tail -n 1)"
	
	# stub is_available
	is_available() {
		return 1
	}
	assertEquals 3 "If MODULE is empty, show a help message and exit. Otherwise show help for the module MODULE." "$(__help_query_mode | head -n 2| tail -n 1)"
	
	# unstub is_available
	unset is_available
	. "$_BASEDIR/core/base.sh"
}

test_help_generic() {
	assertEquals 1 "Usage: enshure QUERY_TYPE [ARGUMENT] ..." "$(__help_generic | head -n 1)"
}
