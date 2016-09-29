_MODULE_TYPE="package"

_STATES="latest:installed:removed"
_TRANSLATED_STATES="$(translate "latest"):$(translate "installed"):$(translate "removed")"
_DEFAULT_STATE="installed"

is_state() {
	## Generic is_state function gets called from the core
	##$1 the state the system should be in

	case "$1" in
		"installed")
			is_state_installed
			;;
		"removed")
			is_state_removed
			;;
		"latest")
			is_state_latest
			;;
	esac
}

attain_state() {
	## Generic attain_state function gets called from the core
	##$1 the state the system should be in

	case "$1" in
		"installed")
			attain_state_installed
			;;
		"removed")
			attain_state_removed
			;;
		"latest")
			attain_state_latest
			;;
	esac
}

is_state_latest() {
	## Placeholder for the is_state_latest command in the module.

	not_implemented
}

is_state_removed() {
	## Placeholder for the is_state_removed command in the module.

	not_implemented
}

is_state_latest() {
	## Placeholder for the is_state_latest command in the module.

	not_implemented
}

attain_state_latest() {
	## Placeholder for the attain_state_latest command in the module.

	not_implemented
}

attain_state_removed() {
	## Placeholder for the attain_state_removed command in the module.

	not_implemented
}

attain_state_installed() {
	## Placeholder for the attain_state_installed command in the module.

	not_implemented
}

verify_requirements() {
	## Placeholder for the verify_requirements command in the module.

	return 0
}
