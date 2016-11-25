
include core/base

# Declare dependencies
# uuencode, uudecode, compress & uncompress should be installed but
# aren't on most systems. Even though there in the POSIX standard.
# So error gracefully if there are no suitable alternatives.

if ! is_available uuencode && ! is_available base64; then
	# If both are unavailable, suggest a POSIX-compliant command.
	require uuencode
fi

if ! is_available uudecode && ! is_available base64; then
	# If both are unavailable, suggest a POSIX-compliant command.
	require uudecode
fi

if ! is_available compress && ! is_available gzip; then
	# If both are unavailable, suggest a POSIX-compliant command.
	require compress
fi

# TODO: Remove the absolute requirement of having mktemp installed
# as it's not defined by the POSIX-standard.
require mktemp

__run_wrap_command_as_user() {
	if [ "$(id -u "$2")" != "$(id -u)" ] ; then
		_cmd=$(escape "$1")
		if is_available su; then
			_cmd="su '$2' -c \"$_cmd\""
		elif is_available sudo; then
			_cmd="sudo -u '$2' $(__run_current_shell) -c \"$_cmd\""
		else
			require su
		fi
		printf '%s' "$_cmd"
	else
		printf '%s' "$1"
	fi
}

run() {
	## Runs a command in the shell and logs it's execution.
	## Running as a user requires sudo or su
	##$1 The command to be executed
	##$2 The user to run the command as, optional.
	##$3 If this is 'no_log' nothing will be logged

	# Just to be safe don't run anything if ENSHURE_VALIDATE is set.
	if [ -n "${ENSHURE_VALIDATE:-}" ]; then
		return 0
	fi

	_cmd="$1"
	_shell=$(__run_current_shell)

	# Make the command execute as another user if requested
	if [ -n "${2:-}" ]; then
		_cmd=$(__run_wrap_command_as_user "$_cmd" "$2")
	fi
	debug "$(translate "Running '\$_cmd'.")"

	# Create temp files for storing command output
	_stdout=$(mktemp /tmp/enshure.stdout.XXXXXX) \
		|| die "$(translate "Could not create temporary file.")" "$_E_FILE_CREATION_FAILED"
	_stderr=$(mktemp /tmp/enshure.stderr.XXXXXX) \
		|| die "$(translate "Could not create temporary file.")" "$_E_FILE_CREATION_FAILED"

	# Log the run of the command
	if [ "no_log" != "${3:-}" ]; then
		printf '%s\n' "$_cmd" >> "$(__log_path)"
	fi

	# Run the command
	_script="$(mktemp)"
	printf '%s\n' "$_cmd" > "$_script"
	_retcode=0
	if [ "no_log" != "${3:-}" ]; then
		"$_shell" "$_script" > "$_stdout" 2> "$_stderr" || _retcode="$?"
	else
		"$_shell" "$_script" 2>&1 || _retcode="$?"
	fi
	rm -rf "$_script"

	# Only log stdout if there was any
	if [ -s "$_stdout" ] && [ "no_log" != "${3:-}" ]; then
		__log_entry STDOUT "$(__run_serialize "$_stdout")"
	fi

	# Only log stderr if there was any
	if [ -s "$_stderr" ] && [ "no_log" != "${3:-}" ]; then
		__log_entry STDERR "$(__run_serialize "$_stderr")"
	fi

	# only log the return code if it's unsuccesfull
	if [ "0" -ne "$_retcode" ] && [ "no_log" != "${3:-}" ]; then
		__log_entry RETURN "$_retcode"
	fi

	# Clean up tempfiles
	rm -rf "$_stdout"
	rm -rf "$_stderr"

	return "$_retcode"
}

__run_serialize() {
	## Makes an entry for the message field of the log.
	##$1 path to the file to serialize

	# XZ compresses large output even better, but has an even larger minimal file.
	# That's why XZ compression is not included

	# find out how to compress
	_compress=''
	_compress_cmd='false'
	if is_available gzip; then
		# To make gzip deterministic see https://wiki.debian.org/ReproducibleBuilds/TimestampsInGzipHeaders
		_compress="GZIP"
		_compress_cmd="gzip --no-name --stdout"
	elif is_available compress; then
		_compress="COMPRESS"
		_compress_cmd="compress -c"
	else
		# Although we never should get here, it's better to be clear
		die "$(translate "Could not find a supported compression command.")" "$_E_UNMET_REQUIREMENT"
	fi

	# find out how to convert to base64
	_b64_cmd=''
	if is_available base64; then
		# clear all newlines in base64.
		# use a pipe to tr instead of -w0 for OSX compatibility
		_b64_cmd="base64 | tr -d '\n'"
	elif is_available uuencode; then
		# chop off the first and the last line (uuencode file information)
		# and clear all newlines
		_b64_cmd="uuencode -m /dev/stdout | awk '{ if (NR > 2) { b64 = b64 line; }; line = \$0;} END { print b64 }'"
	else
		# Although we never should get here, it's better to be clear
		die "$(translate "Could not find a suitable base64 implementation.")" "$_E_UNMET_REQUIREMENT"
	fi

	# create the new command to serialize
	_cmd="${_compress_cmd} | ${_b64_cmd}"

	# serialize the file
	_val=$(eval "$_cmd" < "$1") || true # TODO: Find out why this sometimes fails

	# return output
	printf '%s|%s' "$_compress" "$_val"
}

__run_unserialize() {
	## Parses an entry in the message field of the log. Prints to STDOUT.
	##$1 The serialized command, including the compression prefix.

	_b64=$(printf '%s' "$1" | cut -d'|' -f2)
	_header=$(printf '%s' "$1" | cut -d'|' -f1)

	# find out how to uncompress
	_uncompress_cmd=''
	case "$_header" in
		GZIP)
			require gzip
			_uncompress_cmd='gzip --decompress --stdout'
			;;
		COMPRESS)
			require uncompress
			_uncompress_cmd='uncompress -c'
			;;
		*)
			error "$(translate "The header '\$_header' is unknown for unserialization.")"
			return "$_E_INVALID_SERIALIZE_HEADER"
			;;
	esac

	# find out how to convert from base64
	_b64_cmd=''
	if is_available base64; then
		_b64_cmd="base64 --decode"
	elif is_available uudecode; then
		# prepend the header & footer of uuencode and feed it to decode
		_b64=$(printf '%s\n%s\n%s\n' "begin-base64 664 /dev/stdout" "$_b64" "====")
		_b64_cmd="uudecode"
	else
		die "$(translate "Could not find a suitable base64 implementation.")" "$_E_UNMET_REQUIREMENT"
	fi

	# Unserialize the entry
	printf '%s' "$_b64" | $_b64_cmd | $_uncompress_cmd
}

__run_current_shell() {
	## Gets the current shell in which enSHure is being executed.

	# Check for ZSH, if so return the binary for zsh
	# https://www.zsh.org/mla/workers/2014/msg00041.html

	if [ -n "$ZSH_VERSION" ]; then
		command -v zsh
	else
		ps -p $$ -o args= | cut -d' ' -f1
	fi
}
