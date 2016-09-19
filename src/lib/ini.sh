ini_get() {
	## Displays an option from an ini-file
	##$1 the path to the file, required
	##$2 name of the option, required
	##$3 name of the section, optional
	##> $ ini_get "~/.gitconfig" "name" "user"
	##> name = John Doe

	if [ -z "${3:-}" ]; then
		awk -f "$_BASEDIR/lib/ini/ini_get.awk" -v option="$2" "$1"
	else
		awk -f "$_BASEDIR/lib/ini/ini_get.awk" -v option="$2" -v section="$3" "$1"
	fi
}

ini_get_value() {
	## Displays a value from an ini-file
	##$1 the path to the file, required
	##$2 name of the option, required
	##$3 name of the section, optional
	##> $ ini_get "~/.gitconfig" "name" "user"
	##> John Doe

	_option=$(ini_get "$1" "$2" "${3:-}")
	# Get the second field and trim all leading whitespace
	printf '%s' "$_option" | cut -d'=' -f2 | sed 's/^[[:space:]]*//'
}

ini_has_section() {
	## Returns 0 if the ini-file has the given section
	##$1 the path to the file, required
	##$2 name of the section, required

	grep -q "^\[$2\]" "$1"
}

ini_create_section() {
	## Creates a section in an ini-file, if it not exists
	##$1 the path to the file, required
	##$2 name of the section, required

	if ! ini_has_section "$1" "$2"; then
		printf '[%s]\n' "$2" >> "$1"
	fi
}

ini_delete() {
	## Displays the patch needed to delete an option from an ini-file.
	##$1 the path to the file, required
	##$2 name of the option, required
	##$3 name of the section, optional

	_tmp=$(mktemp)
	if [ -z "${3:-}" ]; then
		awk -f "$_BASEDIR/lib/ini/ini_delete.awk" -v option="$2" "$1" > "$_tmp"
	else
		awk -f "$_BASEDIR/lib/ini/ini_delete.awk" -v option="$2" -v section="$3" "$1" > "$_tmp"
	fi
	diff "$1" "$_tmp"
	rm -rf "$_tmp"
}

ini_set_value() {
	## Displays the patch needed to set a value in an ini-file
	##$1 the path to the file, required
	##$2 name of the option and it's value, required
	##$3 value of the option, required
	##$4 name of the section, optional
	##> $ ini_set "~/.gitconfig" "name" "John Doe" "user"

	# Make sure the section exists
	if [ -n "${4:-}" ]; then
		ini_create_section "$1" "$4"
	fi

	# Set the option
	_tmp=$(mktemp)
	if [ -z "${4:-}" ]; then
		awk -f "$_BASEDIR/lib/ini/ini_set.awk" -v option="$2" -v value="$3" "$1" > "$_tmp"
	else
		awk -f "$_BASEDIR/lib/ini/ini_set.awk" -v option="$2"	-v value="$3" -v section="$4" "$1" > "$_tmp"
	fi

	diff "$1" "$_tmp"
	rm -rf "$_tmp"
}
