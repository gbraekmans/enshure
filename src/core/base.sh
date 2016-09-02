include() {
	## Makes sure source files are only included once. This prevents errors with
	## circular dependencies.
	##$1 one of "core" "lib" "type" "module", followed by /filename
	##> include core/main
	##> include core/msg

	##$_INCLUDED All the paths currently included in the script
	# This file must be included, by definition.
	_INCLUDED=${_INCLUDED:-core/base}

	# Don't do anything if already included
	if printf '%s' ":$_INCLUDED:" | grep ":$1:" > /dev/null 2>&1; then
		return
	fi

	if [ -f "$_BASEDIR/$1.sh" ]; then
		# Include the file
		. "$_BASEDIR/$1.sh"
	else
		return "$_E_FILE_NOT_EXISTS"
	fi

	# Remember the file is already included
	_INCLUDED="${_INCLUDED}:$1"
}

include core/error
include core/msg
include core/log

translate() {
	## A small wrapper around gettext to provide I18n.
	##$1 The string to be translated, in English

	if is_available gettext && is_available envsubst; then
		# Note: The following code is shamelessly copied from gettext.sh
		# but including "gettext.sh" fails under dash and ksh to translate
		# the strings. This solution seems to work even in zsh.

		TEXTDOMAIN='enSHure' TEXTDOMAINDIR="${_BASEDIR}/locale" gettext "$1" \
			| (export PATH $(envsubst --variables "$1"); envsubst "$1")
		# TODO: Fix locales if installed in /usr/share/
	else
		eval "printf '%s' \"$1\""
	fi
}

error() {
	## Displays and logs an error message. Returns 0. If you need
	## an exit at that moment please use die().
	##$1 message to be displayed and recorded in the log
	##> $ error "test"
	##> ERROR: test
	##> $ echo $?
	##> 0

	__msg ERROR "$1"
	__log_entry ERROR "$1"
}

warning() {
	## Displays and logs a warning message. Returns 0.
	##$1 message to be displayed and recorded in the log
	##> $ warning "test"
	##> WARNING: test

	__msg WARNING "$1"
	__log_entry WARNING "$1"
}

info() {
	## Displays and logs an info message. Returns 0.
	##$1 message to be displayed and recorded in the log
	##> $ info "test"
	##> INFO: test

	__msg INFO "$1"
	__log_entry INFO "$1"
}

debug() {
	## Displays a debug message. Returns 0.
	##$1 message to be displayed
	##$2 if this is set to 'log' the message will be logged
	##> $ error "test"
	##> ERROR: test
	##> $ echo $?
	##> 0

	__msg DEBUG "$1"
	if [ 'log' = "${2:-}" ]; then
	__log_entry DEBUG "$1"
	fi
}

is_available() {
	## Checks wether a command is available on the current system.
	##$1 the name of the command
	##> $ is_available test && echo $?
	##> 0
	##> $ is_available foo && echo $?
	##> 1

	# The use of `command -v` is not liked by (older versions of) posh, but it's
	# use is POSIX-compliant:
	# http://pubs.opengroup.org/onlinepubs/9699919799/utilities/command.html
	# http://unix.stackexchange.com/questions/85249/why-not-use-which-what-to-use-then

	command -v "$1" > /dev/null 2>&1
}

# shellcheck disable=SC2034
require() {
	## Displays an error message if the command is not available on the system.
	## Returns 0 if available, greater than 0 if not.
	##$1 the name of the command
	##> $ require test && echo $?
	##> 0
	##> $ require foo && echo $?
	##> ERROR: enSHure requires 'foo' to be installed.
	##> 7
	if is_available "$1"; then
		return 0
	else
		_module=${_MODULE:-enSHure}
		_prog="$1"
		error "$(translate "\$_module requires '\$_prog' to be installed.")"
		exit "$_E_UNMET_REQUIREMENT"
	fi
}

not_implemented() {
	## Shows an error message to the user indicating the functionality
	## is not implemented and returns a nonzero value.
	##> $ not_implemented 
	##> This functionality is not yet implemented in the enSHure core.
	##> $ echo "$?"
	##> 9

	if [ -n "$_MODULE" ]; then
		error "$(translate "\$_MODULE does not implement a function needed to set the state '\$_REQUESTED_STATE'.")"
	else
		error  "$(translate "This functionality is not yet implemented in the enSHure core.")"
	fi
	return "$_E_NOT_IMPLEMENTED"
}

initcap() {
	## Converts the first letter of a string to uppercase, the rest are
	## lowercase. Prints the result to stdout.
	##$1 the string to be converted
	##> $ initcap "what am i?"
	##> What am i?
	##> $ initcap "Me"
	##> Me
	
	_first=$(printf '%s' "$1" | cut -c1 | tr '[:lower:]' '[:upper:]')
	_rest=$(printf '%s' "$1" | cut -c2- | tr '[:upper:]' '[:lower:]')
	printf '%s%s' "$_first" "$_rest"
}
