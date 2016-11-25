_MODULE_TYPE="archive"

_STATES="extracted:compressed"
_TRANSLATED_STATES="$(translate "extracted"):$(translate "compressed")"
_DEFAULT_STATE="extracted"

is_state() {
	## Generic is_state function gets called from the core
	##$1 the state the system should be in

	case "$1" in
		"extracted")
			is_state_extracted
			;;
		"compressed")
			is_state_compressed
			;;
	esac
}

attain_state() {
	## Generic attain_state function gets called from the core
	##$1 the state the system should be in

	case "$1" in
		"extracted")
			attain_state_extracted
			;;
		"compressed")
			attain_state_compressed
			;;
	esac
}

is_state_compressed() {
	## Placeholder for the is_state_compressed command in the module.

	not_implemented
}

is_state_extracted() {
	## Placeholder for the is_state_extracted command in the module.

	not_implemented
}

attain_state_extracted() {
	## Placeholder for the attain_state_extracted command in the module.

	not_implemented
}

attain_state_compressed() {
	## Placeholder for the attain_state_compressed command in the module.

	not_implemented
}

verify_requirements() {
	## Placeholder for the verify_requirements command in the module.

	return 0
}
