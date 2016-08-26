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
			return 2
			;;
	esac
}
