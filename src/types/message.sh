_MODULE_TYPE="message"

_STATES="error:warning:info:debug"
_DEFAULT_STATE="info"

# Note: the message-type is not your average type.
# Any module of this type should implement only the
# get_message function.

_DONT_PRINT_CHANGE="true"
_DONT_LOG_CHANGE="true"


is_state() {
	## Generic is_state function gets called from the core
	##$1 the state the system should be in

	# A message is never in the correct state and needs to be executed always.
	return 1
}

attain_state() {
	## Generic attain_state function gets called from the core
	##$1 the state the system should be in

	_msg=$(get_message)
	case "$1" in
		"error")
			error "$_msg"
			;;
		"warning")
			warning "$_msg"
			;;
		"info")
			info "$_msg"
			;;
		"debug")
			debug "$_msg" log
			;;
	esac
}

get_message() {
	## Placeholder for the get_message command in the module.

	not_implemented
}


verify_requirements() {
	## Placeholder for the verify_requirements command in the module.

	return 0
}
