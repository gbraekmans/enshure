
##$ENSHURE_LOG the location of the enSHure log on the filesystem

. "$_BASEDIR"/core/error.sh

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

__log_is_writeable() {
	## Test if the log is writeable
	[ -w "${ENSHURE_LOG:-/var/log/enshure.log}" ]
}

__log_entry() {
	## Creates an entry in the log
	##$1 Type of the entry: one of the message types or EXEC_LOG
	##$2 Optional. The message for the log entry.

	_entry="#$1|$(__log_date)|${_MODULE:-}|${_IDENTIFIER:-}|${_REQUESTED_STATE:-}|${2:-}\n"

	if __log_should_write_to_stdout; then
		printf "$_entry"
	else
		if ! __log_is_writeable; then
			die $_E_UNWRITEABLE_LOG "Could not write to log file '${ENSHURE_LOG:-/var/log/enshure.log}'."
		fi
		printf "$_entry" >> "${ENSHURE_LOG:-/var/log/enshure.log}"
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

