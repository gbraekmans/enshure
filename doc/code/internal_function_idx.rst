Defined in bin/enshure
----------------------

__expand_path()
###############

Defined in ``bin/enshure``.

replaces '.' and '..' in paths with their directories and
prints the resulting path to STDOUT.

Arguments:

- $1, the path which should be expanded

Example::

  $ cd /root/
  $ expand_path "./.."
  /

Implementation::

  __expand_path() {
  	if [ ! -d "$1" ]; then
  		_dir=$(dirname -- "$1")
  	else
  		_dir="$1"
  	fi
  	printf "$(CDPATH= cd -- "${_dir}" && pwd)"
  }

__main()
########

Defined in ``bin/enshure``.

Main logic of enSHure.

Implementation::

  __main() {
  	# Set up global variables for file inclusion
  	_BINDIR=$(__expand_path "$0")
  	if [ $(printf "$_BINDIR" | head -c 11) = "/usr/local/" ]; then
  		_BASEDIR="/usr/local/share/enshure/"
  	elif [ $(printf "$_BINDIR" | head -c 5) = "/usr/" ]; then
  		_BASEDIR="/usr/share/enshure/"
  	else
  		_BASEDIR=$(__expand_path "${_BINDIR}/../")
  	fi
  	. "$_BASEDIR"/core/main.sh
  	__main_execute "$@"
  }

Defined in core/help.sh
-----------------------

__help_generic()
################

Defined in ``core/help.sh``.

Show the help message if no module is given.

Implementation::

  __help_generic() {
  	cat <<-"EOF"
  	Usage: enshure QUERY [ARGUMENT]
  	   or: enshure MODULE IDENTIFIER REQUESTED_STATE
  	QUERY:
  	EOF
  	__help_query_mode
  }

__help_query_mode()
###################

Defined in ``core/help.sh``.

Parses core/help.txt into a readable format.

Implementation::

  __help_query_mode() {
  	while read _line; do
  		_help_text="$(printf "$_line" | cut -d'|' -f4)"
  		# if fmt is installed (part of coreutils but not of posix std), use it.
  		if which fmt > /dev/null; then
  			_help_text=$(printf "\t$_help_text" | fmt -)
  		fi
  		printf "%s, %s:\n" "$(printf "$_line" | cut -d'|' -f2)" "$(printf "$_line" | cut -d'|' -f3)"
  		printf "$_help_text\n"
  	done < "$_BASEDIR/core/help.txt"
  }

Defined in core/log.sh
----------------------

__log_date()
############

Defined in ``core/log.sh``.

Return the current date in the log-compatible format

Implementation::

  __log_date() {
  	date '+%Y-%m-%d %H:%M:%S'
  	# Note: There is no portable way to convert epoch timestamps.
  	# It would have been better to use these as it's easier to parse
  	# the amount of time elapsed
  	# http://unix.stackexchange.com/questions/2987/how-do-i-convert-an-epoch-timestamp-to-a-human-readable-format-on-the-cli
  	# http://www.etalabs.net/sh_tricks.html, unfortunately the method described here contains a bug. As GNU date +%s gives me a different amount.
  }

__log_entry()
#############

Defined in ``core/log.sh``.

Creates an entry in the log

Arguments:

- $1, Type of the entry: one of the message types or EXEC_LOG
- $2, Optional. The message for the log entry.

Implementation::

  __log_entry() {
  	if ! __log_is_writeable; then
  		die $_E_UNWRITEABLE_LOG "Could not write to log file '${ENSHURE_LOG:-/var/log/enshure.log}'."
  	fi
  	_entry="#$1|$(__log_date)|${_MODULE:-}|${_IDENTIFIER:-}|${_REQUESTED_STATE:-}|${2:-}\n"
  	if __log_should_write_to_stdout; then
  		printf "$_entry"
  	else
  		printf "$_entry" >> "${ENSHURE_LOG:-/var/log/enshure.log}"
  	fi
  }

__log_is_writeable()
####################

Defined in ``core/log.sh``.

Test if the log is writeable

Implementation::

  __log_is_writeable() {
  	[ -w "${ENSHURE_LOG:-/var/log/enshure.log}" ]
  }

__log_should_write_to_stdout()
##############################

Defined in ``core/log.sh``.

Test if the log should write to stdout or not

Implementation::

  __log_should_write_to_stdout() {
  	[ "${ENSHURE_LOG:-}" = "-" ]
  }

Defined in core/main.sh
-----------------------

__main_execute()
################

Defined in ``core/main.sh``.


Implementation::

  __main_execute() {
  	# Error if there are no arguments
  	if [ -z "${1:-}" ]; then
  		die $_E_NO_ARGUMENTS "No arguments given. Use --help or -h for help"
  	fi
  	if __main_is_query_mode "$@"; then
  		__main_query_mode_parse "$@"
  	fi
  }

__main_is_query_mode()
######################

Defined in ``core/main.sh``.

Checks wether the given arguments put enSHure in query or execution mode.

Arguments:

- $1, The first argument given at the command line.

Implementation::

  __main_is_query_mode() {
  	[ "$(echo "$1" | head -c1)" == "-" ]
  }

__main_query_mode_parse()
#########################

Defined in ``core/main.sh``.


Implementation::

  __main_query_mode_parse() {
  	case "$1" in
  		"-h"|"--help")
  			__help_generic
  			;;
  		"-v"|"--version")
  			printf "%s\n" "$_VERSION"
  			;;
  	esac
  }

Defined in core/msg.sh
----------------------

__msg()
#######

Defined in ``core/msg.sh``.

Displays a message to the end user. The message will be logged.

Arguments:

- $1, Type of the message: "BEGIN", "END", "OK", "CHANGE", "ERROR", "WARNING", "INFO", "DEBUG"
- $2, The message displayed to the user

Example::

  $ msg "INFO" "Hello world!"
  INFO: Hello world!

Implementation::

  __msg() {
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
  			"BEGIN")
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
  	echo test
  }

__msg_format_heading()
######################

Defined in ``core/msg.sh``.

Displays a heading to the user

Arguments:

- $1, The message to format as a heading

Implementation::

  __msg_format_heading() {
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

__msg_terminal_supports_colors()
################################

Defined in ``core/msg.sh``.

Returns 0 if terminal supports 8 or more colors, otherwise it returns 1
Although the terminal might support colors, tput must be available.

Implementation::

  __msg_terminal_supports_colors() {
  	( which tput > /dev/null && [ "8" -le $(tput colors) ] )
  }

__msg_terminal_supports_unicode()
#################################

Defined in ``core/msg.sh``.

Returns 0 if terminal supports UTF-8, if not it returns 1

Implementation::

  __msg_terminal_supports_unicode() {
  	[ "UTF-8" = $(printf "$LANG" | cut -d. -f2) ]
  }

