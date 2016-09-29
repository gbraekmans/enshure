test_symlink() {

	TMP=$(mktemp -u)

	TEST_USER=$(/usr/bin/id -un)
	TEST_GROUP=$(/usr/bin/id -gn)

	RESULT=$(enshure symlink "$TMP"  target "$ENSHURE_LOG" user "$TEST_USER" group "$TEST_GROUP")
	assertTrue 1 "$?"
	assertEquals 2 "CHANGE: Symlink $TMP is now present." "$RESULT"

	RESULT=$(enshure symlink "$TMP"  target "$ENSHURE_LOG" user "$TEST_USER" group "$TEST_GROUP")
	assertTrue 3 "$?"
	assertEquals 4 "OK: Symlink $TMP is already present." "$RESULT"

	RESULT=$(enshure symlink "$TMP" absent)
	assertTrue 5 "$?"
	assertEquals 6 "CHANGE: Symlink $TMP is now absent." "$RESULT"

	RESULT=$(enshure symlink "$TMP" absent)
	assertTrue 7 "$?"
	assertEquals 8 "OK: Symlink $TMP is already absent." "$RESULT"

	RESULT=$(enshure symlink "$TMP" user "$TEST_USER" group "$TEST_GROUP")
	assertFalse 9 "$?"
	assertEquals 10 "ERROR: A present state requires a valid target.
ERROR: Not all requirements are met." "$RESULT"

	rm -rf "$TMP"

}
