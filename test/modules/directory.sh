test_directory() {
	TMP=$(mktemp -u)

	TEST_USER=$(/usr/bin/id -un)
	TEST_GROUP=$(/usr/bin/id -gn)

	RESULT=$(enshure directory "$TMP"  user "$TEST_USER" group "$TEST_GROUP" mode 755)
	assertTrue 1 "$?"
	assertEquals 2 "CHANGE: Directory $TMP is now present." "$RESULT"

	RESULT=$(enshure directory "$TMP" user "$TEST_USER" group "$TEST_GROUP" mode 755)
	assertTrue 3 "$?"
	assertEquals 4 "OK: Directory $TMP is already present." "$RESULT"

	RESULT=$(enshure directory "$TMP" absent)
	assertTrue 5 "$?"
	assertEquals 6 "CHANGE: Directory $TMP is now absent." "$RESULT"

	RESULT=$(enshure directory "$TMP" absent)
	assertTrue 7 "$?"
	assertEquals 8 "OK: Directory $TMP is already absent." "$RESULT"

	rm -rf "$TMP"
}
