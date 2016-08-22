#!/bin/sh

#
# Of course FISH is not supported. It doesn't even try to be POSIX-compatible.
#

set -e
set -u
set -o | grep "^pipefail" > /dev/null && set -o pipefail

POSIXLY_CORRECT=0

# Some useful aliases
DIR=$(dirname "$0")
TMP_ERR_DIR=$(mktemp)

# Clean up on exit
on_exit() {
	_exitstatus=$?
	printf "Exited: %i\n" "$_exitstatus"
	rm $TMP_ERR_DIR
	exit "$_exitstatus"
}
trap on_exit EXIT

# Pretty output, underline a line
underline() {
	i=0
	while [ "$i" -lt "${#1}" ]; do
		i=$(expr $i + 1)
		printf "="
	done
	printf "\n"
}

printf "Checking all source files using shellcheck\n"
underline "Checking all source files using shellcheck"

printf "shellcheck %s\n" "$(dirname "$0")/../src/bin/enshure"
shellcheck -s sh "$(dirname "$0")/../src/bin/enshure"
for src in $(find "$(dirname "$0")/../src" -name '*.sh' | sort); do
	printf "shellcheck %s\n" "$src"
	shellcheck -s sh "$src"
done
printf "\n"


# Run all test files
for fil in $(find "$(dirname "$0")/core" -name '*.sh' | sort); do
		# Show info about current test run
		line="Testing $fil"
		printf "$line\n"
		underline "$line"

	# In all the these shells
	for shl in $(printf "bash:dash:ksh:mksh:zsh" | tr ':' "\n"); do
		# only if the shell is installed
		if ! which "$shl" > /dev/null 2> /dev/null; then
			#printf "Skipping tests on $shl. Not installed.\n"
			continue
		fi

		printf 'With %s:\n' "$shl"

		# Force ZSH to be POSIX-compatible enough
		opt=
		[ "$shl" = "zsh" ] && opt="-y -o posixbuiltins -o posixargzero -o posixaliases -o posixstrings -o posixidentifiers -o shfileexpansion"

		# Run the the test
		SHUNIT_PARENT=$0 _BASEDIR="$DIR/../src" $shl $opt $DIR/shunit2 "$fil" 2> "$TMP_ERR_DIR"

		# If there's output to stderr fail.
		if [ "$(stat --printf "%s" "$TMP_ERR_DIR")" -gt "0" ]; then
			cat "$TMP_ERR_DIR"
			printf "Errors in script. Exiting.\n"
			exit 1
		fi
		printf "\n"
	done
	printf "\n"
done
printf "All tests ran succesfully.\n"
