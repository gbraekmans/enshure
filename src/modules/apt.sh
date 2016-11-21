module_type "package"
module_description "$(translate "Installs packages using 'apt-get'.")"

require apt-get
require dpkg-query

argument "package" string identifier "$(translate "The name of the package")" "bash"
argument "sync" boolean required "$(translate "If the repositories should be synced before testing for latest")" "yes" "no"

is_state_installed() {
	dpkg-query -f '${binary:Package}\n' -W | grep -q "^${package}\$"
}

is_state_removed() {
	! is_state_installed
}

is_state_latest() {
	if [ "$sync" = "yes" ]; then
		run "apt-get update"
	fi
	! apt-get -s dist-upgrade | awk '/^Inst/ { print $2 }' | grep -q "^${package}\$"
}

attain_state_installed() {
	run "DEBIAN_FRONTEND=noninteractive apt-get -yq install '$package'"
}

attain_state_latest() {
	attain_state_installed
}

attain_state_removed() {
	run "DEBIAN_FRONTEND=noninteractive apt-get -yq remove '$package'"
	# TODO: Run apt-get autoremove to delete dependencies?
}
