# NOTE: These should be readonly BUT zsh doesn't seem to like this.

die() {
	## What happens if we can't exit cleanly on an error. Be hesitant to use
	## this function, see error().
	##$1 message to be printed on stderr.
	##$2 returncode.
	##> $ die
	##> CRITICAL FAILURE: Something unknown went terribly wrong...

	# Use a generic error if none was given
	if [ -z "${2:-}" ]; then
		_err=$_E_GENERIC
	else
		_err=$2
	fi

	# Print a cryptic message if none was give
	>&2 printf "CRITICAL FAILURE: %s\n" "${1:-Something unknown went terribly wrong...}"
	exit "$_err"
}

# shellcheck disable=SC2034
# SC2034 = $VARIABLE appears unused. Verify it or export it.
{
##$_E_GENERIC A generic errorcode
_E_GENERIC=1
##$_E_NO_ARGUMENTS Errorcode indicating no arguments were given at the command line
_E_NO_ARGUMENTS=2
##$_E_UNKNOWN_MESSAGE_TYPE errorcode if ``__msg`` isn't called correctly
_E_UNKNOWN_MESSAGE_TYPE=3
##$_E_UNWRITEABLE_LOG errorcode if log is not writeable
_E_UNWRITEABLE_LOG=4
##$_E_ARGUMENT_MISSING errorcode if a required argument is missing
_E_ARGUMENT_MISSING=5
##$_E_INVALID_ENUM if the value does not match one of the enum's values
_E_INVALID_ENUM=6
##$_E_UNMET_REQUIREMENT error if a require stmt fails
_E_UNMET_REQUIREMENT=7
}
