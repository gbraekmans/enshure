
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

__run_serialize() {
	## Makes an entry for the message field of the log.
	##$1 path to the file to serialize

	# find out how to compress
	_compress=''
	_compress_cmd='false'
	if is_available compress; then
		_compress="COMPRESS"
		_compress_cmd="compress -c"
	elif is_available gzip; then
		# To make gzip deterministic see https://wiki.debian.org/ReproducibleBuilds/TimestampsInGzipHeaders
		_compress="GZIP"
		_compress_cmd="gzip --no-name --stdout"
	else
		die "Could not find a supported compression command." "$_E_UNMET_REQUIREMENT"
	fi 

	# find out how to convert to base64
	_b64_cmd=''
	if is_available uuencode; then
		# chop off the first and the last line (uuencode file information)
		# and clear all newlines
		_b64_cmd="uuencode -m /dev/stdout | awk '{ if (NR > 2) { b64 = b64 line; }; line = \$0;} END { print b64 }'"
	elif is_available base64; then
		# clear all newlines in base64.
		# use a pipe to tr instead of -w0 for OSX compatibility
		_b64_cmd="base64 | tr -d '\n'"
	else
		die "Could not find a suitable base64 implementation." "$_E_UNMET_REQUIREMENT"
	fi
	
	# create the new command to serialize
	_cmd="${_compress_cmd} | ${_b64_cmd}"
	
	# serialize the file
	_val=$(eval "$_cmd" < "$1")

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
			error "The header '$_header' is unknown for unserialization."
			return "$_E_INVALID_SERIALIZE_HEADER"
			;;
	esac

	# find out how to convert from base64
	_b64_cmd=''
	if is_available uudecode; then
		# prepend the header & footer of uuencode and feed it to decode
		_b64=$(printf '%s\n%s\n%s\n' "begin-base64 664 /dev/stdout" "$_b64" "====")
		_b64_cmd="uudecode"
	elif is_available base64; then
		_b64_cmd="base64  --decode"
	else
		die "Could not find a suitable base64 implementation." "$_E_UNMET_REQUIREMENT"
	fi

	# Unserialize the entry
	printf '%s' "$_b64" | $_b64_cmd | $_uncompress_cmd
}
