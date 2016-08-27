include core/base

__help() {
	## Show the help message if no module is given.
	cat <<-"EOF"
	Usage: enshure QUERY_MODE [ARGUMENT] ...
	   or: enshure MODULE IDENTIFIER REQUESTED_STATE

	QUERY_MODE:
	-h [MODULE], --help [MODULE]:
	    If MODULE is empty, show a help message and exit. Otherwise show
	    help for the module MODULE.

	-v, --version:
	    Print the version of enSHure and exit.

	-t begin|end [NAME], --task begin|end [NAME]:
	    To begin a task you MUST supply the NAME argument. To end a task
	    you MAY NOT supply the name argument. Subtasks are named:
	    task_name::subtask_name. Subtasks can have subtasks.

	-q NAME [ARGS], --query NAME [ARGS]:
	    Runs the query NAME with arguments ARGS.
	    Valid queries are:
	    - current_task
	    - made_change
	    - summary [TASK]
	EOF
}
