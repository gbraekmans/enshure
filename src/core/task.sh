include core/msg
include core/log
include core/query

# TODO: Add logging and querying

__task_has_valid_name() {
	## Returns 0 if task has a valid name, 1 otherwise.
	##$1 the name of the task
	_task=$(__query_current_task)

	if [ -z "$_task" ]; then
		# if there's no task, everything goes, just not a subtask
		case "$1" in
			*::*)
				return 1
				;;
			*)
				# It should have a length
				if [ -z "${1}" ]; then
					return 1
				else
					return 0
				fi
				;;
		esac
	else
		# If it's task, it must be a valid subtask
		case "$1" in
			"$_task"::*)
				# It should have a length
				if [ -z "${1#$_task::}" ]; then
					return 1
				else
					return 0
				fi
				;;
			*)
				return 1
				;;
		esac
	fi
}

__task_begin() {
	## Begins a task
	##$1 the name of the task

	# Error if the task name is not valid
	_task=$(__query_current_task)
	if ! __task_has_valid_name "$1"; then
		_info=''
		if [ -n "$_task" ]; then
			_info=" Current task is '$_task'"
		fi
		error "The name '$1' is not a valid name for a task.$_info"
		return "$_E_INVALID_TASK_NAME"
	fi

	# Display the start of a new task
	__msg HEADING "Task: $1"
	__log_entry "BEGIN" "$1"
}

__task_end() {
	__msg HEADING "Task done"
	__log_entry "END"
}
