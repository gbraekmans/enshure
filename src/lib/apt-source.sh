if [ -z "$_apt_sources_list_location" ]; then
	_apt_sources_list_location="/etc/apt/sources.list"
fi

apt_source_generate() {
	## Generates a sources.list line
	##$1 the type of repository, required
	##$2 the url of the repository, required
	##$3 the distro of the repository, required
	##$4 the components of the repository, seperated by space, required
	type=$1
	url=$2
	distro=$3
	components=$4

	#Simply print the correct line
	printf '%s %s %s %s\n' "$type" "$url" "$distro" "$components"
}

apt_source_find_regex(){
	## Finds a regex in the source files
	##$1 the regex to find, required
	regex=$1

	if grep -q "$regex" ${_apt_sources_list_location}; then
		return 0
	elif [ -d "${_apt_sources_list_location}.d" ]; then
		for fil in ${_apt_sources_list_location}.d/*; do
			if grep -q "$regex" "$fil"; then
				return 0
			fi
		done
	fi
	return 1
}

apt_source_is_available() {
	## Checks a sources.list repo is available, with a component
	##$1 the type of repository, required
	##$2 the url of the repository, required
	##$3 the distro of the repository, required
	##$4 the components of the repository, seperated by space, required
	type=$1
	url=$2
	distro=$3
	component=$4

	regex="^${type}[[:space:]]*${url}[[:space:]]*${distro}.*[[:space:]]*${component}"
	apt_source_find_regex "$regex"
}

apt_source_has_repo() {
	## Checks a sources.list repo is available, with a component
	##$1 the type of repository, required
	##$2 the url of the repository, required
	##$3 the distro of the repository, required

	type=$1
	url=$2
	distro=$3

	regex="^${type}[[:space:]]*${url}[[:space:]]*${distro}"
	apt_source_find_regex "$regex"
}

apt_source_remove() {
	## Removes a repo from sources.list or sources.list.d/*
	##$1 the type of repository, required
	##$2 the url of the repository, required
	##$3 the distro of the repository, required

	type=$1
	url=$2
	distro=$3

	regex="^${type}[[:space:]]*${url}[[:space:]]*${distro}"
	src_fil=""
	if grep -q "$regex" ${_apt_sources_list_location}; then
		src_fil="${_apt_sources_list_location}"
	elif [ -d "${_apt_sources_list_location}.d" ]; then
		for fil in ${_apt_sources_list_location}.d/*; do
			if grep -q "$regex" "$fil"; then
				src_fil="${fil}"
			fi
		done
	fi

	if [ ! -f "${src_fil}" ]; then
		return 1
	fi

	_tmp=$(mktemp)
	grep -v "$regex" "${src_fil}" > "${_tmp}"
	mv "$_tmp" "$src_fil"
}

apt_source_add() {
	## Generates a sources.list line
	##$1 the type of repository, required
	##$2 the url of the repository, required
	##$3 the distro of the repository, required
	##$4 the components of the repository, seperated by space, required
	type=$1
	url=$2
	distro=$3
	components=$4

	if apt_source_has_repo "$type" "$url" "$distro"; then
		apt_source_remove "$type" "$url" "$distro"
	fi
	apt_source_generate "$type" "$url" "$distro" "$components" >> "$_apt_sources_list_location"
}
