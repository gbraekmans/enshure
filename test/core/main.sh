test_main_is_query_mode() {
	# First arugmunt has - as start -> true
	__main_is_query_mode --help
	assertTrue 1 "$?"
	# First argument is not - -> false
	__main_is_query_mode rpm_package bash installed
	assertFalse 2 "$?"
}

oneTimeSetUp() {
	export _BASEDIR="$ENSHURE_SRC"
	. "$ENSHURE_SRC/core/main.sh"
}
