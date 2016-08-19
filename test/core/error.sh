test_die() {
	RES=$(die 2>&1)
	assertEquals "CRITICAL FAILURE: Something unknown went terribly wrong..." "$RES"
}

oneTimeSetUp() {
	export _BASEDIR="$ENSHURE_SRC"
	. "$ENSHURE_SRC/core/error.sh"
}
