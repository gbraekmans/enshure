#!/bin/sh

# Include all source files
_BASEDIR="$(dirname -- "$0")/../src"
. "$_BASEDIR/core/base.sh"
for fil in $(find "$_BASEDIR/core" -name '*.sh'); do
	inc=${fil#$_BASEDIR/}
	include "${inc%.sh}"
done

LANG="C"


to_rst() {
	## Converts a module to an RST file

	# Heading 1
	printf '%s\n' "$_MODULE"
	__msg_underline "$_MODULE"
	printf '\n\n'

	# Description
	printf '%s\nExample::\n\n' "$_MODULE_DESCRIPTION"
	printf '  $ enshure %s %s %s\n' "$_MODULE" "$(printf '%s' "$_ARGUMENTS" | grep '.*|.*|identifier|' | cut -d'|' -f5)" "$_DEFAULT_STATE"
	printf '\n'

	# Valid states
	printf '%s\n' "Type: $_MODULE_TYPE"
	__msg_underline "Type: $_MODULE_TYPE" "-"
	printf '\n\n'
	printf 'States:\n\n'

	(
		IFS=':'
		for state in $_STATES; do
			if [ "$state" = "$_DEFAULT_STATE" ]; then
				printf '* %s (default)\n' "$state"
			else
				printf '* %s\n' "$state"
			fi
		done
		printf '\n'
	)

	# Arguments
	printf 'Arguments\n'
	__msg_underline "Arguments" '-'
	printf '\n\n'


	printf '%s\n' "$_ARGUMENTS" |
	while IFS= read -r _line; do
		_name=$(printf '%s' "$_line" | cut -d'|' -f1)
		_valtype=$(printf '%s' "$_line" | cut -d'|' -f2)
		_argtype=$(printf '%s' "$_line" | cut -d'|' -f3)
		_helpmsg=$(printf '%s' "$_line" | cut -d'|' -f4)
		_example=$(printf '%s' "$_line" | cut -d'|' -f5)

		printf '* | **%s**: %s. %s.\n' "$_name" "$(initcap "$_valtype")" "$(initcap "$_argtype")"
		printf '  | %s\n  | Example: ``%s``\n' "$_helpmsg" "$_example"
	done
}

require() {
	return 0
}

for mod in $_BASEDIR/modules/*; do
	mod=${mod#$_BASEDIR/modules/}
	mod=${mod%.sh}
	printf 'Module: %s\n' "$mod"
	__module_load "$mod"
	mkdir -p "$1"
	to_rst > "$1/$mod.rst"
	_ARGUMENTS=
done
