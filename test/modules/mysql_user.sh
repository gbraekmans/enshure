test_mysql_user() {
	stub mysql mysql_user_absent

	RESULT=$(enshure mysql_user tst present host localhost)
	assertTrue 1 "$?"
	assertEquals 2 "CHANGE: Mysql user tst is now present." "$RESULT"

	stub mysql mysql_user_present

	RESULT=$(enshure mysql_user tst present host localhost)
	assertTrue 3 "$?"
	assertEquals 4 "OK: Mysql user tst is already present." "$RESULT"

	RESULT=$(enshure mysql_user tst absent host localhost)
	assertTrue 5 "$?"
	assertEquals 6 "CHANGE: Mysql user tst is now absent." "$RESULT"

	stub mysql mysql_user_absent

	RESULT=$(enshure mysql_user tst absent host localhost)
	assertTrue 7 "$?"
	assertEquals 8 "OK: Mysql user tst is already absent." "$RESULT"

	stub mysql mysql_user_absent_pw

	RESULT=$(enshure mysql_user tst present host localhost password tst)
	assertTrue 9 "$?"
	assertEquals 10 "CHANGE: Mysql user tst is now present." "$RESULT"

	stub mysql mysql_user_present_pw

	RESULT=$(enshure mysql_user tst present host localhost password tst)
	assertTrue 11 "$?"
	assertEquals 12 "OK: Mysql user tst is already present." "$RESULT"
}
