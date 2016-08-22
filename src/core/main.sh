include core/error
include core/version
include core/help
include core/msg
include core/task

__main_is_query_mode() {
	## Checks wether the given arguments put enSHure in query or execution mode.
	##$1 The first argument given at the command line.
	[ "$(echo "$1" | head -c1)" = "-" ]
}

__main_query_task() {
	## Gets called if enshure -t is given.
	##$1 one of "begin" or "end"
	##$2 if task is begin, the name of the task

	# Check if argument is there
	if [ -z "${1:-}" ]; then
		error "No task specified. Add 'begin' or 'end'."
		exit "$_E_ARGUMENT_MISSING"
	fi

	# Parse the argument
	case "$1" in
		"begin")
			if [ -z "${2:-}" ]; then
				error "No name for the task specified."
				exit "$_E_ARGUMENT_MISSING"
			fi
			task_begin "$2"
			;;
		"end")
			if [ -n "${2:-}" ]; then
				error "A name for an ending task is given. This is not supported."
				exit "$_E_ARGUMENT_MISSING"
			fi
			task_end
			;;
		*)
			error "--task '$1' is invalid: must be 'begin' or 'end'."
			exit "$_E_INVALID_ENUM"
			;;
	esac
}

__main_query_mode_parse() {


	case "$1" in
		"-h"|"--help")
			__help_generic
			;;
		"-v"|"--version")
			printf "%s\n" "$_VERSION"
			;;
		"-t"|"--task")
			shift;
			__main_query_task "$@"
	esac
}

__main_execute() {
	# Error if there are no arguments
	if [ -z "${1:-}" ]; then
		die "No arguments given. Use --help or -h for help" "$_E_NO_ARGUMENTS"
	fi
	if __main_is_query_mode "$@"; then
		__main_query_mode_parse "$@"
	fi
}
