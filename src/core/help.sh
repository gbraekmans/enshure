include core/base
include core/module
include core/query

__help() {
	## Show the help message
	##$1 the module to show the help for, optional.

	if [ -z "${1:-}" ]; then
		__help_generic
	else
		__help_module "$1"
	fi
}

__help_module() {
	## Show the help for a module
	##$1 the name of the module.
	
	_module="$1"
	__module_load "$_module"

	# Print the header
	translate "Module '$_module', of type '$_MODULE_TYPE'."
	printf '\n\n%s\n\n' "$_MODULE_DESCRIPTION"

	# Print the states
	translate "Valid states for this module:"
	printf '\n'
	for _state in $_STATES; do
		printf '    - %s\n' "$_state"
	done
	translate "With the default state being: '\$_DEFAULT_STATE'."
	printf '\n\n'

	# Print the arguments
	translate "Arguments for this module:"
	printf '\n'
	printf '%s\n' "$_ARGUMENTS" |
	while IFS= read -r _line; do
		_name=$(printf '%s' "$_line" | cut -d'|' -f1)
		_valtype=$(printf '%s' "$_line" | cut -d'|' -f2)
		_argtype=$(printf '%s' "$_line" | cut -d'|' -f3)
		_helpmsg=$(printf '%s' "$_line" | cut -d'|' -f4)
		_example=$(printf '%s' "$_line" | cut -d'|' -f5)
		
		case "$_argtype" in
			"identifier")
				_targtype=$(translate "Identifier")
				;;
			"required")
				_targtype=$(translate "Required")
				;;
			"optional")
				_targtype=$(translate "Optional")
				;;
		esac

		case "$_valtype" in
			"string")
				_tvaltype=$(translate "string")
				;;
			"integer")
				_tvaltype=$(translate "integer")
				;;
			"float")
				# TRANSLATORS: As in the numeric kind of float.
				_tvaltype=$(translate "float")
				;;
			"boolean")
				_tvaltype=$(translate "boolean")
				;;
			"enum"*)
				_tvaltype=$(translate "enumaration")
				;;
		esac
		
		_texample=$(translate "Example")

		printf '    - %s: %s, %s\n' "$_name" "$_targtype" "$_tvaltype"
		__help_indent "$_helpmsg" "        "
		__help_indent "$(printf '%s: %s' "$_texample" "$_example")" "        "
		
	done

	# Print an example
	_id_example=$(printf '%s' "$_ARGUMENTS" | grep '.*|.*|identifier|' | cut -d'|' -f5)

	printf '\n%s:\n' "$(translate "Example")"
	printf '$ enshure %s %s %s\n' "$_module" "$_id_example" "$_DEFAULT_STATE"
}

__help_indent() {
	## Indents a message if possible
	##$1 the message
	##$2 the depth given in spaces

	if is_available fmt; then
		printf '%s%s\n' "${2:-}" "$1" | fmt -w $((80 - ${#2}))
	else
		printf "%s\n" "$1"
	fi
}

__help_generic() {
	## Show the help message if no module is given.

	translate "Usage: enshure MODE [ARGUMENTS...]"
	printf '\n\n'
	translate "MODE is either the name of a module or one of the following:"
	printf '\n\n%s\n' '-h [MODULE], --help [MODULE]'
	__help_indent "$(translate "If MODULE is empty, show a help message and exit. Otherwise show help for the module MODULE.")" "    "
	printf '\n%s\n' '-v, --version'
	__help_indent "$(translate "Print the version of enSHure and exit.")" "    "
	printf '\n%s\n' '-t begin|end [NAME], --task begin|end [NAME]'
	__help_indent "$(translate "To begin a task you MUST supply the NAME argument. To end a task you MAY NOT supply the name argument. Subtasks are named: task_name::subtask_name. Subtasks can have subtasks.")" "    "
	printf '\n%s\n' '-q NAME [ARGS], --query NAME [ARGS]'
	__help_indent "$(translate "Runs the query NAME with arguments ARGS. Valid queries are:")" "    "
	for _query in $_QUERIES; do
		printf "    - %s\n" "$_query" | tr ':' ' '
	done
	printf '\n'
	translate "Or MODE is one of the following modules:"
	printf '\n'
	__module_list "    - "
}
