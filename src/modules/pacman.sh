module_type "package"
module_description "$(translate "Installs packages using 'pacman'.")"

require pacman

argument "package" string identifier "$(translate "The name of the package")" "bash"
argument "sync" boolean required "$(translate "If the repositories should be synced before testing for latest")" "yes" "no"

is_state_installed() {
	pacman -Q | cut -d' ' -f1 | grep -q "^${package}\$"
}

is_state_removed() {
	! is_state_installed
}

is_state_latest() {
	if [ "$sync" = "yes" ]; then
		run "pacman -Sy"
	fi
	! pacman -Qu | cut -d' ' -f1 | grep -q "^${package}\$"
}

attain_state_installed() {
	run "pacman --noconfirm -S '$package'"
}

attain_state_latest() {
	attain_state_installed
}

attain_state_removed() {
	run "pacman --noconfir -R '$package'"
}
