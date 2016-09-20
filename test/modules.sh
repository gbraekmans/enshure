#!/bin/sh

set -o | grep -q "^posixargzero" && set -o posixargzero


# Import all the files
# shellcheck disable=SC2044
for src_file in $(find "$(dirname "$0")/modules" -name '*.sh'); do
	. "$src_file"
done

# Add all tests to the suite
# shellcheck disable=SC2013,SC2044
suite() {
	for src_file in $(find "$(dirname "$0")/modules" -name '*.sh' | sort); do
		for tst in $(grep "test_.*()" "$src_file" | cut -d'(' -f1); do
			suite_addTest "$tst"
		done
	done
}


simple_stub() {
	cat > "$TMP_BIN/$1" <<EOF
#!/bin/sh
exit 0
EOF
	chmod +x "$TMP_BIN/$1"
}

stub() {
	cat > "$TMP_BIN/$1" <<"EOF"
#!/bin/sh

main() {
	mkdir -p "$fixtures/$name"
	sum=$(printf '%s' "$*" | md5sum | cut -d' ' -f1)
	if [ ! -f "$fixtures/$name/$sum" ]; then
		tmp=$(mktemp)
		printf '$ %s %s\n' "$bin" "$*" > "$fixtures/$name/$sum"
		/usr/bin/$bin "$@" >> "$tmp" 2>&1
		printf '%s\n' "$?" >> "$fixtures/$name/$sum"
		cat "$tmp" >> "$fixtures/$name/$sum"
		rm -rf "$tmp"
	fi
	cat "$fixtures/$name/$sum" | awk '{if(NR>2)print}'
	retcode=$(cat "$fixtures/$name/$sum" | awk '{if(NR==2)print}')
	exit "$retcode"
}
EOF

	{
	printf 'bin="%s"\n' "$1"
	printf 'name="%s"\n' "${2:-$1}"
	printf 'fixtures="%s/modules/stubs"\n' "$(dirname -- "$0")"
	printf 'main "$@"\n'
 	} >> "$TMP_BIN/$1"

	chmod +x "$TMP_BIN/$1"
}

unstub() {
	rm -rf "${TMP_BIN:?}/$1"
}

# shellcheck disable=SC2034,SC2044
setUp() {
	# Freeze time for logs
	# date() {
	# 	printf '1970-01-01 00:00:00'
	# }

	stub date
	stub id

	# Reset env variables
	ENSHURE_LOG=$(mktemp)
	ENSHURE_VERBOSITY=
	ENSHURE_MODULE_PATH=
	ENSHURE_VALIDATE=

	LANGUAGE='C'
	LANG='C'

	enshure() {
		_ARGUMENTS=""
		_BASEDIR="$(dirname -- "$0")/../src"
		. "$_BASEDIR/core/base.sh"
		include core/main
		__main_execute "$@"
	}
}

oneTimeSetUp() {
	TMP_BIN=$(mktemp -d)
	export PATH="$TMP_BIN/:$PATH"
}

tearDown() {
	# Delete log
	rm -rf "$ENSHURE_LOG"
}

oneTimeTearDown() {
	rm -rf "$TMP_BIN"
}

. "$(dirname "$0")/shunit2"
