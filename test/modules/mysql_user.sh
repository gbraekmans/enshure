test_mysql_user() {
	stub mysql mysql_user_absent

	RESULT=$(enshure mysql_user tst@127.0.0.1 present)
	assertTrue 1 "$?"
	assertEquals 2 "CHANGE: Mysql database tst@127.0.0.1 is now present." "$RESULT"

	stub mysql mysql_user_present

	RESULT=$(enshure mysql_user tst@127.0.0.1 present)
	assertTrue 3 "$?"
	assertEquals 4 "OK: Mysql database : is already present." "$RESULT"

	RESULT=$(enshure mysql_user tst@127.0.0.1 absent)
	assertTrue 5 "$?"
	assertEquals 6 "CHANGE: Mysql database tst is now absent." "$RESULT"

	stub mysql mysql_user_absent

	RESULT=$(enshure mysql_user tst@127.0.0.1 absent)
	assertTrue 7 "$?"
	assertEquals 8 "OK: Mysql database tst@127.0.0.1 is already absent." "$RESULT"

	enshure -q command_output

}
