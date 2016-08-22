__help_query_mode() {
	## Parses core/help.txt into a readable format.
	while read _line; do
		_help_text="$(printf '%s' "$_line" | cut -d'|' -f4)"
		# if fmt is installed (part of coreutils but not of posix std), use it.
		if which fmt > /dev/null; then
			_help_text=$(printf "\t%s" "$_help_text" | fmt -)
		fi
		printf "%s, %s:\n" "$(printf '%s' "$_line" | cut -d'|' -f2)" \
			"$(printf '%s' "$_line" | cut -d'|' -f3)"
		printf '%s\n' "$_help_text"
	done < "$_BASEDIR/core/help.txt"
}

__help_generic() {
	## Show the help message if no module is given.
	cat <<-"EOF"
	Usage: enshure QUERY [ARGUMENT]
	   or: enshure MODULE IDENTIFIER REQUESTED_STATE
	
	QUERY:
	EOF
	__help_query_mode
}
