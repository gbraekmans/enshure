include core/base
include core/module

__help() {
	## Show the help message
	##$1 the module to show the help for, optional.

	if [ -z "${1:-}" ]; then
		__help_generic
	else
		__help_module "$1"
	fi
}

# TODO convert to gettext

__help_module() {
	## Show the help for a module
	##$1 the name of the module.
	
	not_implemented
	#~ _module="$1"
	#~ (
		#~ _args=''
		#~ __module_load "$1"
		#~ cat <<-EOF
		#~ Module '$_module': $_module_desc

		#~ States for all modules of type '$_MODULE_TYPE':
		  #~ - $_STATES
		
		#~ With the default state being '$_DEFAULT_STATE'.

		#~ Arguments for '$_module':
		#~ $_args
		#~ EOF
	#~ )
}

__help_generic() {
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
