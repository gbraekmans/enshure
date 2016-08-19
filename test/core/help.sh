test_help_query_mode() {
	assertEquals 1 "-h <module>, --help <module>:" "$(__help_query_mode | head -n 1)"
	assertEquals 2 "	If no module is given, show a help message and exit. Otherwise" "$(__help_query_mode | head -n 2| tail -n 1)"
	which() {
		return 1
	}
	assertEquals 3 "If no module is given, show a help message and exit. Otherwise show the help for the module." "$(__help_query_mode | head -n 2| tail -n 1)"
	unset which
}

test_help_generic() {
	assertEquals 1 "Usage: enshure QUERY [ARGUMENT]" "$(__help_generic | head -n 1)"
}

oneTimeSetUp() {
	export _BASEDIR="$ENSHURE_SRC"
	. "$ENSHURE_SRC/core/include.sh"
	INCLUDED=
	include core/help
}
