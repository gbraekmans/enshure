test_mysql_database() {

	stub mysql mysql_database_absent

	RESULT=$(enshure mysql_database tst present)
	assertTrue 1 "$?"
	assertEquals 2 "" "$RESULT"

	stub mysql mysql_database_present

	RESULT=$(enshure mysql_database tst present)
	assertTrue 3 "$?"
	assertEquals 4 "" "$RESULT"

	RESULT=$(enshure mysql_database tst absent)
	assertTrue 5 "$?"
	assertEquals 6 "" "$RESULT"

	stub mysql mysql_database_absent

	RESULT=$(enshure mysql_database tst absent)
	assertTrue 7 "$?"
	assertEquals 8 "" "$RESULT"

	enshure -q command_output

	cat "$ENSHURE_LOG"
}
