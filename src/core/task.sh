include core/msg

# TODO: Add logging and querying

task_begin() {
	__msg HEADING "Task: $1"
}

task_end() {
	__msg HEADING "Task done"
}
