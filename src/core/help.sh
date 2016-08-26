include core/base

__help_query_mode() {
	## Parses core/help.txt into a readable format.

	# I know the cat is useless. kcov likes it.
	# TODO: log this bug upstream.
	# shellcheck disable=SC2002
	cat "$_BASEDIR/core/help.txt" | \
	while read -r _line; do
		_help_text="$(printf '%s' "$_line" | cut -d'|' -f4)"
		# if fmt is installed (part of coreutils but not of posix std), use it.
		if is_available fmt; then
			_help_text=$(printf "\t%s" "$_help_text" | fmt -)
		fi
		printf "%s, %s:\n" "$(printf '%s' "$_line" | cut -d'|' -f2)" \
			"$(printf '%s' "$_line" | cut -d'|' -f3)"
		printf '%s\n' "$_help_text"
	done 
}

__help_generic() {
	## Show the help message if no module is given.
	cat <<-"EOF"
	Usage: enshure QUERY_TYPE [ARGUMENT] ...
	   or: enshure MODULE IDENTIFIER REQUESTED_STATE
	
	QUERY_TYPE:
	EOF
	__help_query_mode
}
