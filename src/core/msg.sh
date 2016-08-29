# This file uses UTF-8 characters. Any recent editor should support this.
# There is a solution here:
# http://stackoverflow.com/questions/27652458/whats-the-best-way-to-embed-a-unicode-character-in-a-posix-shell-script
# But I think these days it should be possible to embed unicode in the source.

##$ENSHURE_VERBOSITY what should be printed to the stdout and what not

__msg_terminal_writes_to_stdout() {
	## Checks wether we are outputting to stdout or a file.
	## Returns 0 if we're connected to the stdout
	# see: http://tldp.org/LDP/abs/html/fto.html#TERMTEST
	[ -t 1 ]
}

__msg_terminal_supports_unicode() {
	## Returns 0 if terminal supports UTF-8, if not it returns 1
	[ "UTF-8" = "${LANG##*.}" ]
}

__msg_terminal_supports_colors() {
	## Returns 0 if terminal supports 8 or more colors, otherwise it returns 1
	## Although the terminal might support colors, tput must be available.
	( is_available tput && [ "8" -le "$(tput colors)" ] )
}

__msg_pretty_print() {
	## Returns 0 if all conditions to pretty print are met.
	__msg_terminal_supports_unicode && __msg_terminal_supports_colors && __msg_terminal_writes_to_stdout
}

__msg_meets_verbosity_level() {
	## Returns 0 if the message should be printed at the current
	## verbosity level.
	##$1 The message type of the message
	
	# Check if the verbosity level is valid. If not warn and set to INFO
	ENSHURE_VERBOSITY=${ENSHURE_VERBOSITY:-INFO}
	case "$ENSHURE_VERBOSITY" in
		"ERROR"|"WARNING"|"INFO"|"DEBUG")
			true
			;;
		*)
			__old_verbosity=$ENSHURE_VERBOSITY
			ENSHURE_VERBOSITY="INFO"
			warning "Verbosity level '${__old_verbosity}' unknown, assuming 'INFO'."
			;;
	esac

	case "$1" in
		"ERROR")
			return 0
			;;
		"WARNING")
			if [ "$ENSHURE_VERBOSITY" = "ERROR" ]; then
				return 1
			else
				return 0
			fi
			;;
		"INFO"|"OK"|"CHANGE"|"HEADING")
			if [ "$ENSHURE_VERBOSITY" = "ERROR" ] \
			|| [ "$ENSHURE_VERBOSITY" = "WARNING" ]; then
				return 1
			else
				return 0
			fi
			;;
		"DEBUG")
			if [ ! "$ENSHURE_VERBOSITY" = "DEBUG" ]; then
				return 1
			else
				return 0
			fi
			;;
	esac
}

__msg_format_heading() {
	## Displays a heading to the user
	##$1 The message to format as a heading
	_cols=80
	is_available tput && _cols=$(tput cols)

	# Chop the remainder of the message if larger than the terminal
	_msg=$1
	[ "${#_msg}" -gt "$_cols" ] && _msg=$(printf '%s' "$_msg" | head -c "$_cols")

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
		printf '%s' "$_filler $_msg $_filler"
	else
		printf '%s' "$_msg"
	fi
	# Append an extra = if the msg or the terminal are uneven.
	[ $(( _len % 2 )) -ne $(( _cols % 2 )) ] && printf "="
	printf "\n"
}

__msg() {
	## Displays a message to the end user. The message will be logged.
	##$1 Type of the message: "HEADING", "OK", "CHANGE", "ERROR", "WARNING", "INFO", "DEBUG"
	##$2 The message displayed to the user
	##> $ msg "INFO" "Hello world!"
	##> INFO: Hello world!
	
	# Check if we should print the message
	if ! __msg_meets_verbosity_level "$1"; then
		return 0
	fi

	_msg="$2"
	_prefix=

	if __msg_pretty_print; then
		tput bold # & bright colors
		
		# terminalcodes from: http://wiki.bash-hackers.org/scripting/terminalcodes
		
		case "$1" in
			"HEADING")
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
		printf '%s\n' "${_prefix}${_msg}"
		tput sgr0 # reset colors
	else 
		# we can't pretty print
		# If it's a heading underline the message
		if [ "$1" = "HEADING" ]; then
			printf '%s\n' "$_msg"
			_lines=$(printf '%s' "$_msg" | tr -c '_' '[=*]')
			printf '%s\n\n' "$_lines"
		else
			# Just print the message and it's type
			printf '%s: %s\n' "$1" "$_msg"
		fi
	fi
}
