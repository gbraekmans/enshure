# shellcheck disable=SC2034
test_help() {
	assertEquals 1 "Usage: enshure MODE [ARGUMENTS...]" "$(__help | tail -n +1 | head -n 1)"
	is_available() { return 1; }
	assertEquals 2 "Usage: enshure MODE [ARGUMENTS...]" "$(__help | head -n 1)"

	ENSHURE_MODULE_PATH="$(dirname -- "$0")/core/test_modules"

	assertEquals 3 "Module 'command', of type 'command'." "$(__help command | tail -n +1 | head -n 1)"
	assertEquals 4 "$ enshure command \"touch /root/test\" executed" "$(__help command | tail -n 1)"
}
