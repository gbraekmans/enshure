
include core/error
include core/version
include core/help

__main_is_query_mode() {
	## Checks wether the given arguments put enSHure in query or execution mode.
	##$1 The first argument given at the command line.
	[ "$(echo "$1" | head -c1)" == "-" ]
}

__main_query_mode_parse() {


	case "$1" in
		"-h"|"--help")
			__help_generic
			;;
		"-v"|"--version")
			printf "%s\n" "$_VERSION"
			;;
	esac
}

__main_execute() {
	# Error if there are no arguments
	if [ -z "${1:-}" ]; then
		die $_E_NO_ARGUMENTS "No arguments given. Use --help or -h for help"
	fi
	if __main_is_query_mode "$@"; then
		__main_query_mode_parse "$@"
	fi
}
