test_main_is_query_mode() {
	# First arugmunt has - as start -> true
	__arguments_is_query_mode --help
	assertTrue "$?"
	# First argument is not - -> false
	__arguments_is_query_mode rpm_package bash installed
	assertFalse "$?"
}

oneTimeSetUp() {
	export _BASEDIR="$ENSHURE_SRC"
	. "$ENSHURE_SRC/core/arguments.sh"
}
