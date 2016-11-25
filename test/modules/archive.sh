test_archive() {
	DR=$(mktemp -d)
	ARB=$(mktemp)
	AR="$ARB.tar.gz"

	printf 'test' > "$DR/testfile"

	rm -rf "$AR" && RESULT=$(enshure archive "$AR" compressed directory "$DR")
	assertTrue 1 "$?"
	assertEquals 2 "CHANGE: Archive $AR is now compressed." "$RESULT"

	RESULT=$(enshure archive "$AR" compressed directory "$DR")
	assertTrue 3 "$?"
	assertEquals 4 "OK: Archive $AR is already compressed." "$RESULT"

	rm -rf "$DR"

	RESULT=$(enshure archive "$AR" extracted directory "$DR")
	assertTrue 5 "$?"
	assertEquals 6 "CHANGE: Archive $AR is now extracted." "$RESULT"

	RESULT=$(enshure archive "$AR" extracted directory "$DR")
	assertTrue 7 "$?"
	assertEquals 8 "OK: Archive $AR is already extracted." "$RESULT"

	# enshure -q command_output
	# tar taf "$AR"
	# ls -l "$DR"

	rm -rf "$DR"
	rm -rf "$AR"
	rm -rf "$ARB"
}
