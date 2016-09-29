_MODULE_TYPE="generic"

_STATES="present:absent"
_TRANSLATED_STATES="$(translate "present"):$(translate "absent")"
_DEFAULT_STATE="present"

is_state() {
	## Generic is_state function gets called from the core
	##$1 the state the system should be in

	case "$1" in
		"present")
			is_state_present
			;;
		"absent")
			is_state_absent
			;;
	esac
}

attain_state() {
	## Generic attain_state function gets called from the core
	##$1 the state the system should be in

	case "$1" in
		"present")
			attain_state_present
			;;
		"absent")
			attain_state_absent
			;;
	esac
}

is_state_present() {
	## Placeholder for the is_state_present command in the module.

	not_implemented
}

is_state_absent() {
	## Placeholder for the is_state_absent command in the module.

	not_implemented
}

attain_state_present() {
	## Placeholder for the attain_state_present command in the module.

	not_implemented
}

attain_state_absent() {
	## Placeholder for the attain_state_absent command in the module.

	not_implemented
}

verify_requirements() {
	## Placeholder for the verify_requirements command in the module.

	return 0
}
