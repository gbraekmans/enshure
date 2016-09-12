include core/error
include core/version
include core/help
include core/msg
include core/task
include core/query
include core/run

__main_is_query_mode() {
	## Checks wether the given arguments put enSHure in query or execution mode.
	##$1 The first argument given at the command line.
	[ "$(printf '%s' "$1" | head -c1)" = "-" ]
}

__main_query_task() {
	## Gets called if enshure -t is given.
	##$1 one of "begin" or "end"
	##$2 if task is begin, the name of the task

	# Check if argument is there
	if [ -z "${1:-}" ]; then
		error "$(translate "No task specified. Add 'begin' or 'end'.")"
		exit "$_E_ARGUMENT_MISSING"
	fi

	# Parse the argument
	case "$1" in
		"begin")
			if [ -z "${2:-}" ]; then
				error "$(translate "No name for the task specified.")"
				exit "$_E_ARGUMENT_MISSING"
			fi
			__task_begin "$2"
			;;
		"end")
			if [ -n "${2:-}" ]; then
				error "$(translate "A name for an ending task is given. This is not supported.")"
				exit "$_E_ARGUMENT_MISSING"
			fi
			__task_end
			;;
		*)
			_arg="$1"
			error "$(translate "Argument --task '\$_arg' is invalid: must be 'begin' or 'end'.")"
			exit "$_E_INVALID_ENUM"
			;;
	esac
}

__main_query_mode_parse() {
	## Parses the command if enSHure is started in query mode

	# TODO: Implement facts
	
	case "$1" in
		"-h"|"--help")
			shift
			__help "$@"
			;;
		"-v"|"--version")
			printf "%s\n" "$_VERSION"
			;;
		"-t"|"--task")
			shift
			__main_query_task "$@"
			;;
		"-q"|"--query")
			shift
			query "$@"
			;;
		*)
			# shellcheck disable=SC2034
			_arg=$1
			error "$(translate "Unknown argument '\$_arg'.")"
			return "$_E_UNKNOWN_ARGUMENT"
	esac
}

__main_execute_mode_parse() {
	## Parses the command if started in execute mode

	# Check if required arguments are available
	if [ -z "${1:-}" ] || [ -z "${2:-}" ]; then
		error "$(translate "A module and identifier must be specified.")"
		exit "$_E_ARGUMENT_MISSING"
	fi
	
	# Load the module
	__module_load "$1"

	# Set the identifier
	# shellcheck disable=SC2034
	_IDENTIFIER="$2"

	# Set the state
	# shellcheck disable=SC2034
	_STATE="$(__main_execute_mode_parse_state "$@")"
	if ! __module_is_valid_state; then
		error "$(translate "'\$_STATE' is not a valid state for module '\$_MODULE'.")"
		return "$_E_INVALID_STATE"
	fi

	# Pop the two or three first arguments
	shift && shift
	if [ "$((${#@} % 2))" -eq "1" ]; then
		shift
	fi

	# Parse the arguments
	__module_parse "$@"
	
	# Verify the requirements
	if ! verify_requirements; then
		error "$(translate "Not all requirements are met.")"
		return "$_E_UNMET_REQUIREMENT"
	fi
	
	##$ENSHURE_VALIDATE if this is set only a validation of the modules will occur
	# If only validation was necessary exit here
	if [ -n "${ENSHURE_VALIDATE:-}" ]; then
		return 0
	fi

	# Let the types and modules figure out how to get/set the state
	if is_state "$_STATE"; then
		__log_ok
	else
		attain_state "$_STATE"
		__log_change
	fi
}

__main_execute_mode_parse_state() {
	## Returns the correct state from a number of arguments
	_even_amount_of_args=$((${#} % 2))
	if [ "$_even_amount_of_args" -eq 0 ]; then
		printf '%s' "$_DEFAULT_STATE"
	else
		printf '%s' "$3"
	fi
}

__main_execute() {
	## The main execution function. This is the function called
	## from the main script.
	
	# Error if there are no arguments
	if [ -z "${1:-}" ]; then
		die "$(translate "No arguments given. Use --help or -h for help." "$_E_NO_ARGUMENTS")"
	fi

	# Show some usefull information
	# shellcheck disable=SC2034
	_logpath="$(__log_path)"
	debug "$(translate "Logging to '\$_logpath'")"
	
	# If enSHure is in query mode, parse the arguments.
	if __main_is_query_mode "$@"; then
		__main_query_mode_parse "$@"
	else
		__main_execute_mode_parse "$@"
	fi
}
