# Uncomment the following functions to recreate the fixtures

mysql_setup() {
	# unstub mysql
	#
	# OLD_LOG=$ENSHURE_LOG
	# ENSHURE_LOG=/dev/null
	#
	# enshure mysql_user tst
	# enshure mysql_database tst
	#
	# ENSHURE_LOG=$OLD_LOG
	return 0
}

mysql_teardown() {
	# unstub mysql
	#
	# OLD_LOG=$ENSHURE_LOG
	# ENSHURE_LOG=/dev/null
	#
	# enshure mysql_user tst absent
	# enshure mysql_database tst absent
	#
	# ENSHURE_LOG=$OLD_LOG
	#
	# enshure -q command_output
	# cat "$ENSHURE_LOG"
	return 0
}

test_mysql_grant() {
	mysql_setup

	stub mysql mysql_grant_absent

	RESULT=$(enshure mysql_grant tst present db tst)
	assertTrue 1 "$?"
	assertEquals 2 "CHANGE: Mysql grant tst is now present." "$RESULT"

	stub mysql mysql_grant_present

	RESULT=$(enshure mysql_grant tst present db tst)
	assertTrue 3 "$?"
	assertEquals 4 "OK: Mysql grant tst is already present." "$RESULT"

	RESULT=$(enshure mysql_grant tst absent db tst)
	assertTrue 5 "$?"
	assertEquals 6 "CHANGE: Mysql grant tst is now absent." "$RESULT"

	stub mysql mysql_grant_absent

	RESULT=$(enshure mysql_grant tst absent db tst)
	assertTrue 7 "$?"
	assertEquals 8 "OK: Mysql grant tst is already absent." "$RESULT"

	mysql_teardown
}

test_mysql_grant_wg() {
	mysql_setup

	stub mysql mysql_grant_absent_wg

	RESULT=$(enshure mysql_grant tst present db tst with_grant yes)
	assertTrue wg1 "$?"
	assertEquals wg2 "CHANGE: Mysql grant tst is now present." "$RESULT"

	stub mysql mysql_grant_present_wg

	RESULT=$(enshure mysql_grant tst present db tst with_grant yes)
	assertTrue wg3 "$?"
	assertEquals wg4 "OK: Mysql grant tst is already present." "$RESULT"
	mysql_teardown
}

test_mysql_grant_read() {
	mysql_setup

	stub mysql mysql_grant_absent_read

	RESULT=$(enshure mysql_grant tst present db tst permissions read)
	assertTrue read1 "$?"
	assertEquals read2 "CHANGE: Mysql grant tst is now present." "$RESULT"

	stub mysql mysql_grant_present_read

	RESULT=$(enshure mysql_grant tst present db tst permissions read)
	assertTrue read3 "$?"
	assertEquals read4 "OK: Mysql grant tst is already present." "$RESULT"
	mysql_teardown
}

test_mysql_grant_write() {
	mysql_setup

	stub mysql mysql_grant_absent_write

	RESULT=$(enshure mysql_grant tst present db tst permissions write)
	assertTrue write1 "$?"
	assertEquals write2 "CHANGE: Mysql grant tst is now present." "$RESULT"

	stub mysql mysql_grant_present_write

	RESULT=$(enshure mysql_grant tst present db tst permissions write)
	assertTrue write3 "$?"
	assertEquals write4 "OK: Mysql grant tst is already present." "$RESULT"
	mysql_teardown

}
