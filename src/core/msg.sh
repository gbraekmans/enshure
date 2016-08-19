# This file uses UTF-8 characters. Any recent editor should support this.
# There is a solution here:
# http://stackoverflow.com/questions/27652458/whats-the-best-way-to-embed-a-unicode-character-in-a-posix-shell-script
# But I think these days it should be possible to embed unicode in the source.

include core/error
include core/log
include core/version

__msg_terminal_supports_unicode() {
	## Returns 0 if terminal supports UTF-8, if not it returns 1
	[ "UTF-8" = $(printf "$LANG" | cut -d. -f2) ]
}

__msg_terminal_supports_colors() {
	## Returns 0 if terminal supports 8 or more colors, otherwise it returns 1
	## Although the terminal might support colors, tput must be available.
	( which tput > /dev/null && [ "8" -le $(tput colors) ] )
}

# terminalcodes from: http://wiki.bash-hackers.org/scripting/terminalcodes

__msg_format_heading() {
	## Displays a heading to the user
	##$1 The message to format as a heading
	_cols=80
	which tput > /dev/null && _cols=$(tput cols)

	# Chop the remainder of the message if larger than the terminal
	_msg=$1
	[ "${#_msg}" -gt "$_cols" ] && _msg=$(printf "$_msg" | head -c $_cols)

	# Create a string of "=" to fill before & after the message
	_len=${#_msg}
	_fill=$((_cols - _len - 2))
	_fill=$((_fill / 2))
	_i=0
	_filler=
	while [ "$_i" -lt "$_fill" ]; do
		_i=$((_i + 1))
		_filler="$_filler="
	done

	# Return result
	if [ -n "$_filler" ]; then
		printf "$_filler $_msg $_filler"
	else
		printf "$_msg"
	fi
	# Append an extra = if the msg or the terminal are uneven.
	[ $(( _len % 2 )) -ne $(( _cols % 2 )) ] && printf "="
	printf "\n"
}

__msg() {
	## Displays a message to the end user. The message will be logged.
	##$1 Type of the message: "BEGIN", "END", "OK", "CHANGE", "ERROR", "WARNING", "INFO", "DEBUG"
	##$2 The message displayed to the user
	##> $ msg "INFO" "Hello world!"
	##> INFO: Hello world!

	case "$1" in
		"BEGIN"|"END"|"OK"|"CHANGE"|"ERROR"|"WARNING"|"INFO"|"DEBUG")
			true
			;;
		*)
			__msg 'ERROR' "Unsupported message type: '$1'"
			return $_E_UNKNOWN_MESSAGE_TYPE
			;;
	esac

	_msg="$2"
	_prefix=

	if __msg_terminal_supports_unicode && __msg_terminal_supports_colors; then
		tput bold # bright colors
		case "$1" in
			"BEGIN"|"END")
				tput setaf 7 # white
				_msg=$(__msg_format_heading "$_msg")
				;;
			"OK")
				tput setaf 2 # green
				_prefix=" ✓ "
				;;
			"CHANGE")
				tput setaf 4 # blue
				_prefix=" ✎ "
				;;
			"ERROR")
				tput setaf 1 # red
				_prefix=" ✗ "
				;;
			"WARNING")
				tput setaf 3 # yellow
				_prefix=" ⚠ "
				;;
			"INFO")
				tput setaf 4 # blue
				_prefix=" ℹ "
				;;
			"DEBUG")
				tput setaf 7 # white
				_prefix=" ↳ "
				;;
		esac
		printf "${_prefix}${_msg}\n"
		tput sgr0 # reset colors
	else
		printf "$1: $_msg\n"
	fi
	__log_entry "$1" "$2"
}

msg_ok() {
	## Indicates that no action was needed. Related ``__msg()``.
	##$1 The message displayed to the user
	__msg "OK" "$1"
}

msg_change() {
	## Indicates that the system of the user has been changed. Related ``__msg()``.
	##$1 The message displayed to the user
	__msg "CHANGE" "$1"
}

msg_error() {
	## Indicates something unexpected or unrecoverable has occured,
	## usually followed by a nonzero exit. Related ``__msg()``.
	##$1 The message displayed to the user
	__msg "ERROR" "$1"
}

msg_warning() {
	## Indicates an error was recovered or the functionality of the program is
	## is severely restricted by it. Related ``__msg()``.
	##$1 The message displayed to the user
	__msg "WARNING" "$1"
}

msg_info() {
	## Notifies the user of something important. Related ``__msg()``.
	##$1 The message displayed to the user
	__msg "INFO" "$1"
}

msg_debug() {
	## Notifies the user of things the developers finds useful. Related ``__msg()``.
	##$1 The message displayed to the user
	__msg "DEBUG" "$1"
}

__msg_begin() {
	## Indicates the begin of a enSHure run. Related ``__msg()``.
	__msg "BEGIN" "enSHure $_VERSION: BEGIN TRANSACTION"
}

__msg_end() {
	## Indicates the end of a enSHure run. Related ``__msg()``.
	__msg "END" "enSHure $_VERSION: END TRANSACTION"
}

