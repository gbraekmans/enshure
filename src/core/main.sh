include core/error
include core/version
include core/help
include core/msg

require tst

__main_is_query_mode() {
	## Checks wether the given arguments put enSHure in query or execution mode.
	##$1 The first argument given at the command line.
	[ "$(echo "$1" | head -c1)" = "-" ]
}

__main_query_transaction() {
	## Gets called if enshure -t is given.
	##$1 one of "begin" or "end"

	# Check if argument is there
	if [ -z "${1:-}" ]; then
		msg_error "No transaction type specified. Add 'begin' or 'end'."
		exit "$_E_ARGUMENT_MISSING"
	fi

	# Parse the argument
	case "$1" in
		"begin")
			__msg_begin
			;;
		"end")
			__msg_end
			;;
		*)
			msg_error "Transaction type '$1' is invalid: must be 'begin' or 'end'."
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
		"-t"|"--transaction")
			shift;
			__main_query_transaction "$@"
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
