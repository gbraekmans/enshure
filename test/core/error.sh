test_die() {
	RES=$(die 2>&1)
	assertEquals 1 "$_E_GENERIC" "$?"
	assertEquals 2 "CRITICAL FAILURE: Something unknown went terribly wrong..." "$RES"
	RES=$(die "Test Case" 2>&1)
	assertEquals 3 "$_E_GENERIC" "$?"
	assertEquals 4 "CRITICAL FAILURE: Test Case" "$RES"
	RES=$(die "Test Case" 5 2>&1)
	assertEquals 5 "5" "$?"
	assertEquals 6 "CRITICAL FAILURE: Test Case" "$RES"
}
