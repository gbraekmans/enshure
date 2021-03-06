include core/msg
include core/log
include core/query

__task_is_nested() {
	## Returns 0 if task is nested. 1 otherwise.
	##$1 the name of the task
	case "$1" in
		*::*)
			return 0
			;;
		*)
			return 1
			;;
	esac
}

__task_has_valid_name() {
	## Returns 0 if task has a valid name, 1 otherwise.
	##$1 the name of the task
	_task=$(__query_current_task)

	if [ -z "$_task" ]; then
		# if there's no task, everything goes, just not a subtask
		case "$1" in
			*'::'*)
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
			"${_task}::"*)
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
	_current_task=$(__query_current_task)
	if ! __task_has_valid_name "$1"; then
		_task="$1"
		if [ -n "$_current_task" ]; then
			error "$(translate "'\$_task' is not a valid name for a task. Current task is '\$_current_task'.")"
		else
			error "$(translate "'\$_task' is not a valid name for a task.")"
		fi
		return "$_E_INVALID_TASK_NAME"
	fi

	# shellcheck disable=SC2034
	_display_task="$1"
	if __msg_pretty_print; then
		# Replace '::' with ' → ' for pretty task names
		# shellcheck disable=SC2034
		_display_task=$(printf '%s' "$1" | sed 's/::/ → /g')
	fi

	# Display the start of a new task
	if __task_is_nested "$1"; then
		__msg INFO "$(translate "Subtask: \$_display_task")"
	else
		__msg HEADING "$(translate "Task: \$_display_task")"
	fi
	__log_entry "BEGIN" "$1"
}

__task_end() {
	_task="$(__query_current_task)"

	# Cannot end a task if there's no task
	if [ -z "$_task" ]; then
		error "$(translate "Not in a task right now.")"
		return "$_E_NOT_IN_A_TASK"
	fi

	# Pretty-print the task
	# shellcheck disable=SC2034
	_display_task="$_task"
	if __msg_pretty_print; then
		# Replace '::' with ' → ' for pretty task names
		# shellcheck disable=SC2034
		_display_task=$(printf '%s' "$_task" | sed 's/::/ → /g')
	fi

	# Display the start of a new task
	if __task_is_nested "$_task"; then
		__msg INFO "$(translate "Done: \$_display_task")"
	else
		__msg HEADING "$(translate "Done: \$_display_task")"
	fi
	__log_entry "END"
}
