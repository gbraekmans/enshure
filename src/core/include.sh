include() {
	## Makes sure source files are only included once. This prevents errors with
	## circular dependencies.

	##$1 one of "core" "lib" "type" "module", followed by /filename

	##> include core/main
	##> include core/msg

	# Don't do anything if already included
	if printf ":$_INCLUDED:" | grep ":$1:" > /dev/null; then
		return
	fi

	# Include the file
	. "$_BASEDIR/$1.sh"

	# Remember the file is already included
	if [ -z "$_INCLUDED" ]; then
		_INCLUDED="$1"
	else
		_INCLUDED="${_INCLUDED}:$1"
	fi
}
