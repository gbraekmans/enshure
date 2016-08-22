test_help_query_mode() {
	assertEquals 1 "-h [MODULE], --help [MODULE]:" "$(__help_query_mode | head -n 1)"
	assertEquals 2 "	If MODULE is empty, show a help message and exit. Otherwise show" "$(__help_query_mode | head -n 2| tail -n 1)"
	which() {
		return 1
	}
	assertEquals 3 "If MODULE is empty, show a help message and exit. Otherwise show help for the module MODULE." "$(__help_query_mode | head -n 2| tail -n 1)"
	unset which
}

test_help_generic() {
	assertEquals 1 "Usage: enshure QUERY [ARGUMENT]" "$(__help_generic | head -n 1)"
}

oneTimeSetUp() {
	. "$_BASEDIR/core/base.sh"
	include core/help
}
