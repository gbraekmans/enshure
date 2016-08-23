test_msg_terminal_supports_unicode() {
	# LANG is UTF8 -> true
	LANG="en_US.UTF-8" __msg_terminal_supports_unicode
	assertTrue 1 "$?"
	# LANG is not UTF8 -> false
	LANG="en_GB.ISO-8859-1" __msg_terminal_supports_unicode
	assertFalse 2 "$?"
}

test_msg_terminal_writes_to_stdout() {
	__msg_terminal_writes_to_stdout
	assertTrue 1 "$?"
	__msg_terminal_writes_to_stdout > /dev/null
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
	for tp in $(printf "OK CHANGE ERROR WARNING INFO DEBUG" | tr ' ' "\n"); do
		RESULT=$(LANG="en_GB.ISO-8859-1" __msg "$tp" "Testing")
		assertTrue 1 "$?"
		assertEquals 2 "$tp: Testing" "$RESULT"
	done
}

test_msg_heading() {
	RESULT=$(LANG="en_GB.ISO-8859-1" __msg "HEADING" "Testing")
	VALID=$(printf '%s\n%s' "Testing" "=======")
	assertTrue 1 "$?"
	assertEquals 2 "$VALID" "$RESULT"
}

test_msg_meets_verbosity_level() {
	ENSHURE_VERBOSITY="ERROR"
	__msg_meets_verbosity_level ERROR
	assertTrue 1 "$?"
	#__msg_meets_verbosity_level WARNING
	#assertFalse 2 "$?"
	__msg_meets_verbosity_level INFO
	assertFalse 3 "$?"
	__msg_meets_verbosity_level DEBUG
	assertFalse 4 "$?"

	ENSHURE_VERBOSITY="WARNING"
	__msg_meets_verbosity_level ERROR
	assertTrue 5 "$?"
	__msg_meets_verbosity_level WARNING
	assertTrue 6 "$?"
	__msg_meets_verbosity_level INFO
	assertFalse 7 "$?"
	__msg_meets_verbosity_level DEBUG
	assertFalse 8 "$?"

	ENSHURE_VERBOSITY="INFO"
	__msg_meets_verbosity_level ERROR
	assertTrue 9 "$?"
	__msg_meets_verbosity_level WARNING
	assertTrue 10 "$?"
	__msg_meets_verbosity_level INFO
	assertTrue 11 "$?"
	__msg_meets_verbosity_level DEBUG
	assertFalse 12 "$?"

	ENSHURE_VERBOSITY="DEBUG"
	__msg_meets_verbosity_level ERROR
	assertTrue 13 "$?"
	__msg_meets_verbosity_level WARNING
	assertTrue 14 "$?"
	__msg_meets_verbosity_level INFO
	assertTrue 15 "$?"
	__msg_meets_verbosity_level DEBUG
	assertTrue 16 "$?"

	ENSHURE_VERBOSITY="WARNING"
	__msg_meets_verbosity_level OK
	assertFalse 17 "$?"
	__msg_meets_verbosity_level CHANGE
	assertFalse 18 "$?"
	__msg_meets_verbosity_level HEADING
	assertFalse 19 "$?"

	ENSHURE_VERBOSITY="INFO"
	__msg_meets_verbosity_level OK
	assertTrue 20 "$?"
	__msg_meets_verbosity_level CHANGE
	assertTrue 21 "$?"
	__msg_meets_verbosity_level HEADING
	assertTrue 22 "$?"

}

setUp() {
	ENSHURE_VERBOSITY="DEBUG"
	ENSHURE_LOG="/dev/null"
}

oneTimeSetUp() {
	. "$_BASEDIR/core/base.sh"
	include core/msg
}
