_MODULE_TYPE="service"

_STATES="available:started:stopped:enabled:disabled:restarted:unavailable"
_TRANSLATED_STATES="$(translate "available"):$(translate "started"):$(translate "stopped"):$(translate "enabled"):$(translate "disabled"):$(translate "restarted"):$(translate "unavailable")"
_DEFAULT_STATE="available"

is_state() {
	## Generic is_state function gets called from the core
	##$1 the state the system should be in
	case "$1" in
		"restarted")
			# A service is never restarted
			return 1
			;;
		"available")
			is_state_enabled && is_state_started
			;;
		"unavailable")
			( ! is_state_enabled ) && ( ! is_state_started )
			;;
		"disabled")
			! is_state_enabled
			;;
		"stopped")
			! is_state_started
			;;
		"enabled")
			is_state_enabled
			;;
		"started")
			is_state_started
			;;
	esac
}

attain_state() {
	## Generic attain_state function gets called from the core
	##$1 the state the system should be in
	case "$1" in
		"restarted")
			attain_state_restarted
			;;
		"available")
			attain_state_enabled
			attain_state_started
			;;
		"unavailable")
			attain_state_disabled
			attain_state_stopped
			;;
		"disabled")
			attain_state_disabled
			;;
		"stopped")
			attain_state_stopped
			;;
		"enabled")
			attain_state_enabled
			;;
		"started")
			attain_state_started
			;;
	esac
}

is_state_enabled() {
	## Placeholder for the is_state_enabled command in the module.

	not_implemented
}

is_state_started() {
	## Placeholder for the is_state_started command in the module.

	not_implemented
}

attain_state_restarted() {
	## Placeholder for the attain_state_restarted command in the module.

	not_implemented
}

attain_state_started() {
	## Placeholder for the attain_state_started command in the module.

	not_implemented
}

attain_state_stopped() {
	## Placeholder for the attain_state_stopped command in the module.

	not_implemented
}

attain_state_enabled() {
	## Placeholder for the attain_state_enabled command in the module.

	not_implemented
}

attain_state_disabled() {
	## Placeholder for the attain_state_disabled command in the module.

	not_implemented
}

verify_requirements() {
	## Placeholder for the verify_requirements command in the module.

	return 0
}
