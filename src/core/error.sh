# NOTE: These should be readonly BUT zsh doesn't seem to like this.

die() {
	## What happens if we can't exit cleanly on an error.

	##$1 Returncode.
	##$2 Message to be printed on stderr.

	# Use a generic error if none was given
	if [ -z "${1:-}" ]; then
		_err=$_E_GENERIC
	else
		_err=$1
	fi

	# Print a cryptic message if none was give
	>&2 printf "CRITICAL FAILURE: ${2:-Something unknown went terribly wrong...}\n"
	exit $_err
}

##$_E_GENERIC A generic errorcode
_E_GENERIC=1
##$_E_NO_ARGUMENTS Errorcode indicating no arguments were given at the command line
_E_NO_ARGUMENTS=2
##$_E_UNKNOWN_MESSAGE_TYPE errorcode if ``__msg`` isn't called correctly
_E_UNKNOWN_MESSAGE_TYPE=3
##$_E_UNWRITEABLE_LOG errorcode if log is not writeable
_E_UNWRITEABLE_LOG=4
