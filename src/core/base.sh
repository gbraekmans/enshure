include() {
	## Makes sure source files are only included once. This prevents errors with
	## circular dependencies.

	##$1 one of "core" "lib" "type" "module", followed by /filename

	##> include core/main
	##> include core/msg

	##$_INCLUDED All the paths currently included in the script
	_INCLUDED=${_INCLUDED:-}

	# Don't do anything if already included
	if printf '%s' ":$_INCLUDED:" | grep ":$1:" > /dev/null 2>&1; then
		return
	fi

	# Include the file
	. "$_BASEDIR/$1.sh"

	# Remember the file is already included
	if [ -z "$_INCLUDED" ]; then
		_INCLUDED="$1"
	else
		_INCLUDED="${_INCLUDED}:$1"
	fi
}

include core/error
include core/msg
include core/log

error() {
	## Displays and logs an error message.
	##$1 message to be displayed and recorded in the log

	__msg ERROR "$1"
	__log_entry ERROR "$1"
}

is_available() {
	## Checks wether a command is available on the current system.
	##$1 the name of the command
	##> is_available echo

	# The use of `command -v` is not liked by (older versions of) posh, but it's
	# use is POSIX-compliant:
	# http://pubs.opengroup.org/onlinepubs/9699919799/utilities/command.html
	# http://unix.stackexchange.com/questions/85249/why-not-use-which-what-to-use-then

	command -v "$1" > /dev/null 2>&1
}

require() {
	## Displays an error message if the command is not available on the system.
	## Returns 0 if available, greater than 0 if not.
	##$1 the name of the command
	if is_available "$1"; then
		return 0
	else
		error "${MODULE:-enSHure} requires '$1' available on the system"
		return "$_E_UNMET_REQUIREMENT"
	fi
}
