test_msg_terminal_supports_unicode() {
	# LANG is UTF8 -> true
	LANG="en_US.UTF-8" __msg_terminal_supports_unicode
	assertTrue 1 "$?"
	# LANG is not UTF8 -> false
	LANG="en_GB.ISO-8859-1" __msg_terminal_supports_unicode
	assertFalse 2 "$?"
}

test_msg_terminal_supports_colors() {
	# 2 colors -> false
	(
		tput() {
			printf "2"
		}
  	__msg_terminal_supports_colors
  )
	assertFalse 1 "$?"
	# system has not got tput installed -> false
	(
		which() {
			return 1
		}
  	__msg_terminal_supports_colors
  )
	assertFalse 2 "$?"
	# system has 8 or more colors and tput -> true
	(
		tput() {
			printf "8"
		}
  	__msg_terminal_supports_colors
  )
	assertTrue 3 "$?"
}

test_msg_format_heading() {
	# Only support 10 cols
	tput() {
		printf "10"
	}
	RESULT=$(__msg_format_heading "TEST")
	assertEquals 1 "== TEST ==" "$RESULT"

	# Only support 9 cols
	tput() {
		printf "9"
	}
	RESULT=$(__msg_format_heading "TEST")
	assertEquals 2 "= TEST ==" "$RESULT"

	# Only support 3 cols
	tput() {
		printf "3"
	}
	RESULT=$(__msg_format_heading "TEST")
	assertEquals 3 "TES" "$RESULT"

	# Tput isn't installed assume 80
	which() {
		return 1
	}
	RESULT=$(__msg_format_heading "TEST")
	assertEquals 4 "===================================== TEST =====================================" "$RESULT"

	unset tput
	unset which
}


test_msg() {
	# invalid type -> false
	RESULT=$(LANG="en_GB.ISO-8859-1" __msg "INVALID" "Testing")
	assertFalse 1 "$?"
	assertEquals 2 "ERROR: Unsupported message type: 'INVALID'" "$RESULT"
	# test valid types -> true
	for tp in $(printf "OK CHANGE ERROR WARNING INFO DEBUG" | tr ' ' "\n"); do
		RESULT=$(LANG="en_GB.ISO-8859-1" __msg "$tp" "Testing")
		assertTrue 3 "$?"
		assertEquals 4 "$tp: Testing" "$RESULT"
	done
}

test_msg_custom_functions() {
	# return -> true
	for tp in $(printf "OK CHANGE ERROR WARNING INFO DEBUG" | tr ' ' "\n"); do
		SUFFIX=$(printf "$tp" | tr 'A-Z' 'a-z')
		printf "    msg_$SUFFIX\n"
		RESULT=$(LANG="en_GB.ISO-8859-1" msg_$SUFFIX "Testing")
		assertTrue 1 "$?"
		assertEquals 2 "$tp: Testing" "$RESULT"
	done
}

test_msg_begin_end() {
	# return -> true
	for tp in $(printf "BEGIN END" | tr ' ' "\n"); do
		SUFFIX=$(printf "$tp" | tr 'A-Z' 'a-z')
		printf "  __msg_$SUFFIX\n"
		RESULT=$(LANG="en_GB.ISO-8859-1" __msg_$SUFFIX)
		assertTrue 1 "$?"
		assertEquals 2 "$tp: enSHure $_VERSION: $tp TRANSACTION" "$RESULT"
	done
}

setUp() {
	ENSHURE_LOG="/dev/null"
}

oneTimeSetUp() {
	. "$_BASEDIR/core/base.sh"
	include core/msg
	include core/version
}
