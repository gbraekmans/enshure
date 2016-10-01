test_mysql_database() {

	stub mysql mysql_database_absent

	RESULT=$(enshure mysql_database tst present)
	assertTrue 1 "$?"
	assertEquals 2 "CHANGE: Mysql database tst is now present." "$RESULT"

	stub mysql mysql_database_present

	RESULT=$(enshure mysql_database tst present)
	assertTrue 3 "$?"
	assertEquals 4 "OK: Mysql database tst is already present." "$RESULT"

	RESULT=$(enshure mysql_database tst absent)
	assertTrue 5 "$?"
	assertEquals 6 "CHANGE: Mysql database tst is now absent." "$RESULT"

	stub mysql mysql_database_absent

	RESULT=$(enshure mysql_database tst absent)
	assertTrue 7 "$?"
	assertEquals 8 "OK: Mysql database tst is already absent." "$RESULT"
}
