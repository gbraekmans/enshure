module_type "generic"
module_description "$(translate "Adds or removes an apt source")"

include lib/apt-source

argument "url" string identifier "$(translate "The url to the repository.")" "ftp://ftp.debian.org/debian/dists/"
argument "distro" string required "$(translate "Name of the distribution")" "stable"
argument "components" string required "$(translate "Names of the components")" "main contrib non-free"
argument "type" 'enum(deb:deb-src)' required "$(translate "Type of repository")" "deb-src" "deb"

is_state_present() {
	for comp in $components; do
		if ! apt_source_is_available "$type" "$url" "$distro" "$comp"; then
			return 1
		fi
	done
	return 0
}

is_state_absent() {
	! is_state_present
}

attain_state_present() {
	apt_source_add "$type" "$url" "$distro" "$components"
}

attain_state_absent() {
	apt_source_remove "$type" "$url" "$distro"
}
