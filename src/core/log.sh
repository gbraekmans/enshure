#!/bin/sh

##$ENSHURE_LOG the location of the enSHure log on the filesystem

include core/error

__log_path() {
	printf '%s' "${ENSHURE_LOG:-/var/log/enshure.log}"
}

__log_date() {
	## Return the current date in the log-compatible format
	date '+%Y-%m-%d %H:%M:%S'
	# Note: There is no portable way to convert epoch timestamps.
	# It would have been better to use these as it's easier to parse
	# the amount of time elapsed
	# http://unix.stackexchange.com/questions/2987/how-do-i-convert-an-epoch-timestamp-to-a-human-readable-format-on-the-cli
	# http://www.etalabs.net/sh_tricks.html, unfortunately the method described here contains a bug. As GNU date +%s gives me a different amount.
}

__log_should_write_to_stdout() {
	## Test if the log should write to stdout or not
	[ "${ENSHURE_LOG:-}" = "-" ]
}

__log_entry() {
	## Creates an entry in the log
	##$1 Type of the entry: one of the message types or EXEC_LOG
	##$2 Optional. The message for the log entry.

	_entry="#$1|$(__log_date)|$(id -u)|${_MODULE:-}|${_IDENTIFIER:-}|${_STATE:-}|${2:-}"
	# shellcheck disable=SC2034
	_logfile="$(__log_path)"

	if __log_should_write_to_stdout; then
		printf '%s\n' "$_entry"
	else
		# Create file if it does not exist
		if [ ! -e "$(__log_path)" ]; then
			( printf '' > "$(__log_path)" ) 2> /dev/null || die "$(translate "Could not write to log file '\$_logfile'.")" "$_E_UNWRITEABLE_LOG"
		fi
		# Only log if writeable
		if [ ! -w "$(__log_path)" ]; then
			die "$(translate "Could not write to log file '\$_logfile'.")" "$_E_UNWRITEABLE_LOG"
		fi
		printf '%s\n' "$_entry" >> "$(__log_path)"
	fi
}

__log_can_write_module_functions() {
	[ -n "$_MODULE" ] && [ -n "$_IDENTIFIER" ] && [ -n "$_STATE" ]
}

# shellcheck disable=SC2034
message_change() {
	## Displays the message to be printed on a change. Overrideable in a module.
	##> $ change_message
	##> MODULE IDENTIFIER is now STATE

	_mod="$(initcap "$_MODULE"  | sed 's/\_/ /g')"
	_state="$(translated_state)"
	printf '%s' "$(translate "\$_mod \$_IDENTIFIER is now \$_state.")"
}

# shellcheck disable=SC2034
message_ok() {
	## Displays the message to be printed on OK. Overrideable in a module.
	##> $ ok_message
	##> MODULE IDENTIFIER is already STATE
	_mod="$(initcap "$_MODULE" | sed 's/_/ /g')"
	_state="$(translated_state)"
	printf '%s' "$(translate "\$_mod \$_IDENTIFIER is already \$_state.")"
}

__log_change() {
	if ! __log_can_write_module_functions; then
		die "$(translate "Can not signal 'CHANGE' when no module is loaded." "$_E_NOT_IN_A_MODULE")"
	fi
	##$_DONT_PRINT_CHANGE if this is set, CHANGE and OK messages are not printed
	##$_DONT_LOG_CHANGE if this is set, CHANGE and OK messages are not logged
	if [ -z "${_DONT_PRINT_CHANGE:-}" ]; then
		__msg "CHANGE" "$(message_change)"
	fi
	if [ -z "${_DONT_LOG_CHANGE:-}" ]; then
		__log_entry "CHANGE" "$(LANG='C' message_change)"
	fi
}

__log_ok() {
	if ! __log_can_write_module_functions; then
		die "$(translate "Can not signal 'OK' when no module is loaded.")" "$_E_NOT_IN_A_MODULE"
	fi

	if [ -z "${_DONT_PRINT_CHANGE:-}" ]; then
		__msg "OK" "$(message_ok)"
	fi
	if [ -z "${_DONT_LOG_CHANGE:-}" ]; then
		__log_entry "OK" "$(LANG='C' message_ok)"
	fi
}

# I'll probably implement date time differences as optional using something like this:

#python3 <<-"EOF"
#from datetime import datetime
#import math

#fmt = "%Y-%m-%d %H:%M:%S"

#def seconds_between(d1, d2):
#    d1 = datetime.strptime(d1, fmt)
#    d2 = datetime.strptime(d2, fmt)
#    return abs((d2 - d1).seconds)

#def human_time(secs):
#    units = [("day", 86400), ("hour", 3600), ("minute", 60), ("second", 1)]
#    parts = []
#    for unit, mul in units:
#        if secs / mul >= 1 or mul == 1:
#            if mul > 1:
#                n = int(math.floor(secs / mul))
#                secs -= n * mul
#            else:
#                n = secs if secs != int(secs) else int(secs)
#            parts.append("%s %s%s" % (n, unit, "" if n == 1 else "s"))
#    if len(parts) == 1:
#        return parts[0]
#    else:
#        return ", ".join(parts[0:-1]) + " and " + parts[-1]

#print(human_time(seconds_between("2016-08-17 09:05:26", "2013-05-16 05:35:42")))
#EOF
