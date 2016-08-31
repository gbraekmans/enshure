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
	_generic_msg="$(translate "Something unknown went terribly wrong...")"
	# shellcheck disable=SC2034
	_msg="${1:-$_generic_msg}"
	printf '%s\n' "$(translate "CRITICAL FAILURE: \$_msg")" >&2
	exit "$_err"
}

# shellcheck disable=SC2034
# SC2034 = VARIABLE appears unused. Verify it or export it.
{
##$_E_GENERIC A generic errorcode
_E_GENERIC=1

##$_E_NO_ARGUMENTS errorcode indicating no arguments were given at the command line
_E_NO_ARGUMENTS=2

##$_E_INVALID_TASK_NAME if the name your giving to the task is invalid
_E_INVALID_TASK_NAME=3

##$_E_UNWRITEABLE_LOG errorcode if log is not writeable
_E_UNWRITEABLE_LOG=4

##$_E_ARGUMENT_MISSING errorcode if a required argument is missing
_E_ARGUMENT_MISSING=5

##$_E_INVALID_ENUM if a value does not match one of the pre-defined values
_E_INVALID_ENUM=6

##$_E_UNMET_REQUIREMENT error if a require statement fails
_E_UNMET_REQUIREMENT=7

##$_E_NOT_IN_A_TASK you need to be in a task to use this feature
_E_NOT_IN_A_TASK=8

##$_E_NOT_IMPLEMENTED the functionality is not implemented
_E_NOT_IMPLEMENTED=9

##$_E_NOT_IN_A_MODULE you need to be in a module to use this feature
_E_NOT_IN_A_MODULE=10

##$_E_UNKNOWN_ARGUMENT the argument specified is not supported
_E_UNKNOWN_ARGUMENT=11

##$_E_INVALID_SERIALIZE_HEADER the header of the serialized message is not known.
_E_INVALID_SERIALIZE_HEADER=12

##$_E_FILE_CREATION_FAILED the creation of a file failed
_E_FILE_CREATION_FAILED=13
}
