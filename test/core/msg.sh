test_msg_terminal_supports_unicode() {
	# LANG is UTF8 -> true
	LANG="en_US.UTF-8" __msg_terminal_supports_unicode
	assertTrue 1 "$?"
	# LANG is not UTF8 -> false
	LANG="en_GB.ISO-8859-1" __msg_terminal_supports_unicode
	assertFalse 2 "$?"
}

test_msg_terminal_writes_to_stdout() {
	# Skip test if not writing to stdout
	if [ ! -t 1 ]; then
		startSkipping
	fi

	isSkipping || __msg_terminal_writes_to_stdout
	assertTrue 1 "$?"

	isSkipping && endSkipping

	__msg_terminal_writes_to_stdout > /dev/null
	assertFalse 2 "$?"
}

test_msg_terminal_supports_colors() {
	# 2 colors -> false
	tput() {
		printf "2"
	}
	__msg_terminal_supports_colors
 	assertFalse 1 "$?"
	unset -f tput

	# system has not got tput installed -> false
	is_available() {
		return 1
	}
	__msg_terminal_supports_colors
	assertFalse 2 "$?"

	# system has 8 or more colors and tput -> true
	tput() {
		printf "8"
	}
	__msg_terminal_supports_colors
	unset -f tput
	assertTrue 3 "$?"
}

test_msg_pretty_print() {
	__msg_terminal_supports_unicode() { return 0; }
	__msg_terminal_supports_colors() { return 0; }
	__msg_terminal_writes_to_stdout() { return 0; }

	__msg_pretty_print
	assertTrue 1 "$?"

	__msg_terminal_supports_unicode() { return 1; }
	__msg_terminal_supports_colors() { return 0; }
	__msg_terminal_writes_to_stdout() { return 0; }

	__msg_pretty_print
	assertFalse 2 "$?"
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

	# Only support 6 cols
	tput() {
		printf "6"
	}
	RESULT=$(__msg_format_heading "TEST")
	assertEquals 4 "TEST" "$RESULT"

	# Only support 8 cols
	tput() {
		printf "8"
	}
	RESULT=$(__msg_format_heading "TEST")
	assertEquals 5 "= TEST =" "$RESULT"

	# Tput isn't installed assume 80
	is_available() {
		return 1
	}
	RESULT=$(__msg_format_heading "TEST")
	assertEquals 6 "===================================== TEST =====================================" "$RESULT"

	unset -f tput
}

# shellcheck disable=SC2034
test_msg() {
	ENSHURE_VERBOSITY='DEBUG'
	for tp in $(printf "OK CHANGE ERROR WARNING INFO DEBUG" | tr ' ' "\n"); do
		RESULT=$(LANG="en_GB.ISO-8859-1" __msg "$tp" "Testing")
		assertTrue 1 "$?"
		assertEquals 2 "$tp: Testing" "$RESULT"
	done

	__msg_terminal_supports_unicode() { return 0; }
	__msg_terminal_supports_colors() { return 0; }
	__msg_terminal_writes_to_stdout() { return 0; }

	# Only execute if tput is insalled
	if ! command -v tput > /dev/null; then
		startSkipping
	fi

	isSkipping || RESULT=$(__msg ERROR test)
	assertTrue 3 "$?"
	printf '%s' "$RESULT" | grep -q " ✗ test"
	assertTrue 4 "$?"

	isSkipping || RESULT=$(__msg WARNING test)
	assertTrue 5 "$?"
	printf '%s' "$RESULT" | grep -q " ⚠ test"
	assertTrue 6 "$?"

	isSkipping || RESULT=$(__msg OK test)
	assertTrue 7 "$?"
	printf '%s' "$RESULT" | grep -q " ✓ test"
	assertTrue 8 "$?"

	isSkipping || RESULT=$(__msg CHANGE test)
	assertTrue 9 "$?"
	printf '%s' "$RESULT" | grep -q " ✎ test"
	assertTrue 10 "$?"

	isSkipping || RESULT=$(__msg INFO test)
	assertTrue 11 "$?"
	printf '%s' "$RESULT" | grep -q " ℹ test"
	assertTrue 12 "$?"

	isSkipping || RESULT=$(__msg DEBUG test)
	assertTrue 13 "$?"
	printf '%s' "$RESULT" | grep -q " ↳ test"
	assertTrue 14 "$?"

	isSkipping || RESULT=$(__msg HEADING test)
	assertTrue 15 "$?"
	printf '%s' "$RESULT" | grep -q "= test ="
	assertTrue 16 "$?"

	isSkipping && endSkipping
}

test_msg_heading() {
	RESULT=$(LANG="en_GB.ISO-8859-1" __msg "HEADING" "Testing")
	VALID=$(printf '%s\n%s' "Testing" "=======")
	assertTrue 1 "$?"
	assertEquals 2 "$VALID" "$RESULT"
}

# shellcheck disable=SC2034
test_msg_meets_verbosity_level() {
	ENSHURE_VERBOSITY="ERROR"
	__msg_meets_verbosity_level ERROR
	assertTrue 1 "$?"
	__msg_meets_verbosity_level WARNING
	assertFalse 2 "$?"
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

	# Don't error on invalid verbosity but inform the user
	# shellcheck disable=SC2034
	ENSHURE_VERBOSITY="WHATEVER"
	RESULT=$(__msg_meets_verbosity_level ERROR)
	assertTrue 23 "$?"
	assertEquals 24 "WARNING: Verbosity level 'WHATEVER' unknown, assuming 'INFO'." "$RESULT"
}

test_msg_underline() {
	RESULT=$(__msg_underline 'test')
	assertTrue 1 "$?"
	assertEquals 2 "====" "$RESULT"

	RESULT=$(__msg_underline 'test' '-')
	assertTrue 1 "$?"
	assertEquals 2 "----" "$RESULT"
}
