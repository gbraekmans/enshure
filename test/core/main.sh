test_main_is_query_mode() {
	# First arugmunt has - as start -> true
	__main_is_query_mode --help
	assertTrue 1 "$?"
	# First argument is not - -> false
	__main_is_query_mode rpm_package bash installed
	assertFalse 2 "$?"
}

test_main_query_mode_parse() {
	assertEquals 1 "$_VERSION" "$(__main_query_mode_parse -v)"
	assertEquals 2 "$(__main_query_mode_parse -v)" "$(__main_query_mode_parse --version)"
	assertTrue 3 "__main_query_mode_parse -h | head -n 1 | grep ^Usage:"
	assertEquals 4 "$(__main_query_mode_parse -h)" "$(__main_query_mode_parse --help)"
}

oneTimeSetUp() {
	export _BASEDIR="$ENSHURE_SRC"
	. "$ENSHURE_SRC/core/main.sh"
	. "$ENSHURE_SRC/core/version.sh"
}
