test_file() {
	TMP=$(mktemp -u)

	simple_stub wget

	TEST_USER=$(/usr/bin/id -un)
	TEST_GROUP=$(/usr/bin/id -gn)

	RESULT=$(enshure file "$TMP" content "Hello World!\n")
	assertTrue 1 "$?"
	assertEquals 2 "CHANGE: File $TMP is now present." "$RESULT"
	assertEquals 3 "Hello World!" "$(cat "$TMP")"

	RESULT=$(enshure file "$TMP" content "Hello World!\n")
	assertTrue 4 "$?"
	assertEquals 5 "OK: File $TMP is already present." "$RESULT"
	assertEquals 6 "Hello World!" "$(cat "$TMP")"

	TMP2=$(mktemp)
	printf 'A test' > "$TMP2"

	RESULT=$(enshure file "$TMP" present source_file "$TMP2" user "$TEST_USER" group "$TEST_GROUP" mode "444")
	assertTrue 7 "$?"
	assertEquals 8 "CHANGE: File $TMP is now present." "$RESULT"
	assertEquals 9 "A test" "$(cat "$TMP")"

	RESULT=$(enshure file "$TMP" present source_file "$TMP2" user "$TEST_USER" group "$TEST_GROUP" mode "444")
	assertTrue 10 "$?"
	assertEquals 11 "OK: File $TMP is already present." "$RESULT"
	assertEquals 12 "A test" "$(cat "$TMP")"

	chmod 666 "$TMP"
	printf 'not' > "$TMP"
	chmod 400 "$TMP"

	RESULT=$(enshure file "$TMP" present source_file "$TMP2" user "$TEST_USER" group "$TEST_GROUP" mode "444")
	assertTrue 13 "$?"
	assertEquals 14 "CHANGE: File $TMP is now present." "$RESULT"
	assertEquals 15 "A test" "$(cat "$TMP")"

	RESULT=$(enshure file "$TMP" present source_file "$TMP2" user "$TEST_USER" group "$TEST_GROUP" mode "444")
	assertTrue 16 "$?"
	assertEquals 17 "OK: File $TMP is already present." "$RESULT"
	assertEquals 18 "A test" "$(cat "$TMP")"


	RESULT=$(enshure file "$TMP" present source_url "http://google.com/")
	assertTrue 19 "$?"
	assertEquals 20 "CHANGE: File $TMP is now present." "$RESULT"

	chmod 600 "$TMP"
	printf '' > "$TMP"

	RESULT=$(enshure file "$TMP" present source_url "http://google.com/")
	assertTrue 21 "$?"
	assertEquals 22 "OK: File $TMP is already present." "$RESULT"

	RESULT=$(enshure file "$TMP" absent)
	assertTrue 23 "$?"
	assertEquals 24 "CHANGE: File $TMP is now absent." "$RESULT"


	RESULT=$(enshure file "$TMP" present source_url "http://google.com/" content "Hello World!")
	assertFalse 21 "$?"
	assertEquals 22 "ERROR: You can set only one of content, source_file or source_url
ERROR: Not all requirements are met." "$RESULT"

	rm -rf "$TMP" "$TMP2"
}
