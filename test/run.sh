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
TMP=$(mktemp)

# Clean up on exit
on_exit() {
	rm $TMP
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

# Run all test files
for fil in $(find "$(dirname "$0")/core" -name '*.sh'); do
	# In all the these shells
	for shl in $(printf "bash:dash:mksh:ksh:posh:zsh" | tr ':' "\n"); do
		# only if the shell is installed
		if ! which "$shl" > /dev/null 2> /dev/null; then
			printf "Skipping tests on $shl. Not installed.\n"
			continue
		fi

		# Show info about current test run
		line="Testing $fil with $shl"
		printf "$line\n"
		underline "$line"

		# Force ZSH to be POSIX-compatible enough
		opt=
		[ "$shl" = "zsh" ] && opt="-y -o posixbuiltins -o posixargzero -o posixaliases -o posixstrings -o posixidentifiers -o shfileexpansion"

		# Run the the test
		SHUNIT_PARENT=$0 ENSHURE_SRC="$DIR/../src" $shl $opt $DIR/shunit2 "$fil" 2> "$TMP"

		# If there's output to stderr fail.
		if [ "$(stat --printf "%s" "$TMP")" -gt "0" ]; then
			cat $TMP
			printf "Errors in script. Exiting.\n"
			exit 1
		fi
		printf "\n"
	done
	printf "\n"
done
printf "All tests ran succesfully.\n"
