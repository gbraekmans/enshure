create_source_file() {
	cat > "$1" <<EOF
deb http://ftp.nluug.nl/pub/os/Linux/distr/debian/ stretch main non-free contrib
deb-src http://ftp.nluug.nl/pub/os/Linux/distr/debian/ stretch main non-free contrib

deb http://security.debian.org/debian-security stretch/updates main contrib non-free
deb-src http://security.debian.org/debian-security stretch/updates main contrib non-free
EOF
	mkdir -p "${1}.d"
	cat > "$1.d/wheezy" <<EOF
deb http://ftp.nluug.nl/pub/os/Linux/distr/debian/ wheezy main
EOF
}

test_apt_source_generate() {
	assertEquals 1 "$(apt_source_generate deb http://security.debian.org/debian-security stretch/updates main)" "deb http://security.debian.org/debian-security stretch/updates main"
}

# shellcheck disable=SC2034
test_apt_source_is_available() {
	TMP=$(mktemp)

	create_source_file "$TMP"
	_apt_sources_list_location="$TMP"

	apt_source_is_available deb http://ftp.nluug.nl/pub/os/Linux/distr/debian/ stretch contrib
	assertTrue 1 "$?"

	apt_source_is_available deb http://ftp.nluug.nl/ stretch contrib
	assertFalse 2 "$?"

	apt_source_is_available deb http://ftp.nluug.nl/pub/os/Linux/distr/debian/ wheezy main
	assertTrue 3 "$?"

	apt_source_is_available deb http://ftp.nluug.nl/pub/os/Linux/distr/debian/ wheezy contrib
	assertFalse 4 "$?"

	rm -rf "$TMP"
	rm -rf "${TMP}.d"
}

# shellcheck disable=SC2034
test_apt_source_has_repo() {
	TMP=$(mktemp)

	create_source_file "$TMP"
	_apt_sources_list_location="$TMP"

	apt_source_has_repo deb http://ftp.nluug.nl/pub/os/Linux/distr/debian/ stretch
	assertTrue 1 "$?"

	apt_source_has_repo deb http://ftp.nluug.nl/ woody
	assertFalse 2 "$?"

	apt_source_has_repo deb http://ftp.nluug.nl/pub/os/Linux/distr/debian/ wheezy
	assertTrue 3 "$?"

	rm -rf "$TMP"
	rm -rf "${TMP}.d"
}

# shellcheck disable=SC2034
test_apt_source_remove() {
	TMP=$(mktemp)

	create_source_file "$TMP"
	_apt_sources_list_location="$TMP"

	apt_source_remove deb http://ftp.nluug.nl/pub/os/Linux/distr/debian/ stretch
	assertTrue 1 "$?"
	#cat "$TMP"
	assertEquals 2 "dbbe37a3c37c8e0c7665056193ceee97" "$(md5sum "$TMP" | awk '{print $1}')"

	apt_source_remove deb http://ftp.nluug.nl/pub/os/Linux/distr/debian/ wheezy
	assertTrue 3 "$?"
	#cat "$TMP.d/wheezy"
	assertEquals 4 "d41d8cd98f00b204e9800998ecf8427e" "$(md5sum "$TMP.d/wheezy" | awk '{print $1}')"


	apt_source_remove deb http://ftp.nluug.nl/pub/os/Linux/distr/debian/ woody
	assertFalse 5 "$?"

	rm -rf "$TMP"
	rm -rf "${TMP}.d"
}
# shellcheck disable=SC2034
test_apt_source_add() {
	TMP=$(mktemp)

	create_source_file "$TMP"
	_apt_sources_list_location="$TMP"

	apt_source_add deb http://ftp.nluug.nl/pub/os/Linux/distr/debian/ stretch main
	assertTrue 1 "$?"
	#cat "$TMP"
	assertEquals 2 "258cda06e6979f32e25dcf46ebf4107d" "$(md5sum "$TMP" | awk '{print $1}')"

	rm -rf "$TMP"
	rm -rf "${TMP}.d"
}
