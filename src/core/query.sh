
__query_current_task() {
	## Prints the current task
	awk -f "$_BASEDIR/core/query/current_task.awk" "$(__log_path)"
}

__query_made_change() {
	## Returns 0 if last action made a change, 1 otherwise.
	## If there was no reliable information return 2.
	_last_action=$(awk -f "$_BASEDIR/core/query/last_action_status.awk" "$(__log_path)")
	case "$_last_action" in
		"CHANGE")
			return 0
			;;
		"OK")
			return 1
			;;
		*)
			# if something went wrong, or the log file is empty, assume
			# no change has been made with the last action.
			return 2
			;;
	esac
}

__query_summary() {
	## Prints a summary to the stdout of all changes.
	##$1 A task to act as filter.

	awk -f "$_BASEDIR/core/query/summary.awk" -v "filtered_task=${1:-}" "$(__log_path)"
}


query() {
	## Runs a query against the log. Check the help for documentation
	## which queries can run and what the return values are.
	##$1 the name of the query
	##$2 Optional arguments: $3, $4 ... are also supported
	##> $ query current_task
	##> webserver
	##> $ query summary webserver
	##> change: 3
	##> ok: 15
	##> total: 18
	
	# Check if argument is there
	if [ -z "${1:-}" ]; then
		error "No query specified. Use -h to get a list of all queries."
		return "$_E_ARGUMENT_MISSING"
	fi

	# Parse the argument
	case "$1" in
		"current_task")
			__query_current_task
			;;
		"made_change")
			__query_made_change
			;;
		"summary")
			__query_summary "${2:-}"
			;;
		*)
			error "--query '$1' is invalid. Use -h to get a list of all queries."
			return "$_E_INVALID_ENUM"
			;;
	esac
}
