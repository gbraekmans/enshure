_MODULE_TYPE="command"

_STATES="executed"
_DEFAULT_STATE="executed"

is_state() {
	## Generic is_state function gets called from the core
	##$1 the state the system should be in

	is_state_executed
}

attain_state() {
	## Generic attain_state function gets called from the core
	##$1 the state the system should be in

	attain_state_executed
}

is_state_executed() {
	## Placeholder for the is_state_executed command in the module.

	not_implemented
}

attain_state_executed() {
	## Placeholder for the attain_state_executed command in the module.

	not_implemented
}
