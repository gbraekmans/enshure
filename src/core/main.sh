include core/error
include core/version
include core/help
include core/msg
include core/task
include core/query

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
			error "$(translate "--task '\$_arg' is invalid: must be 'begin' or 'end'.")"
			exit "$_E_INVALID_ENUM"
			;;
	esac
}

__main_query_mode_parse() {
	## Parses the command if enSHure is started in query mode

	# TODO: Implement facts
	
	case "$1" in
		"-h"|"--help")
			__help
			;;
		"-v"|"--version")
			printf "%s\n" "$_VERSION"
			;;
		"-t"|"--task")
			shift;
			__main_query_task "$@"
			;;
		"-q"|"--query")
			shift;
			query "$@"
			;;
		*)
			_arg=$1
			error "$(translate "Unknown argument '\$_arg'.")"
			return "$_E_UNKNOWN_ARGUMENT"
	esac
}

__main_execute() {
	## The main execution function. This is the function called
	## from the main script.
	
	# Error if there are no arguments
	if [ -z "${1:-}" ]; then
		die "$(translate "No arguments given. Use --help or -h for help." "$_E_NO_ARGUMENTS")"
	fi

	# Show some usefull information
	_logpath="$(__log_path)"
	debug "$(translate "Logging to '\$_logpath'")"
	
	# If enSHure is in query mode, parse the arguments.
	if __main_is_query_mode "$@"; then
		__main_query_mode_parse "$@"
	fi
}
