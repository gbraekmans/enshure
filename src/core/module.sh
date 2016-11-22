include core/base
include core/error

##$_DEFAULT_STATE The default state of the module-type
##$_IDENTIFIER The value of the identifier argument
##$_MODULE The currently loaded module
##$_MODULE_DESCRIPTION A description for the currently loaded module
##$_MODULE_TYPE The type of the current module
##$_STATE The requested state for the module
##$_STATES All valid states for the module


module_type() {
	## Loads the correct type for the module.
	##$1 the name of the module type
	##> $ module_type service

	_module_type="$1"
	if [ -f "$_BASEDIR/types/${_module_type}.sh" ]; then
		# Load the type
		# shellcheck disable=SC1090
		. "$_BASEDIR/types/${_module_type}.sh"
	else
		die "$(translate "No such module-type: '\$_module_type'")"
	fi
}

argument() {
	## Adds an argument to the module.
	##$1 the name, for example: file, user, path, ...
	##$2 the value-type, one of: string, integer, float, boolean or enum(...)
	##$3 the argurment-type, one of: identifier, required or optional
	##$4 help text for the argument
	##$5 an example for the help text
	##$6 the default value for optional arguments, not required.

	# TODO: Create better error codes

	# Error if type is not yet loaded
	if [ -z "${_MODULE_TYPE:-}" ]; then
		die "$(translate "Can't add an argument before a module type is loaded")"
	fi

	# If there is already an argument with the same name delete it.
	_ARGUMENTS=$(printf '%s' "${_ARGUMENTS:-}" | sed "s/^${1}|.*//g")

	# Check if value type is valid
	case "$2" in
		"string"|"integer"|"float"|"boolean")
			true
			;;
		"enum"*)
			if ! printf '%s' "$2" | grep -q '^enum(.*)$'; then
				# shellcheck disable=SC2034
				_value_type="$2"
				error "$(translate "The enum '\$_value_type' is of the wrong format.")"
				return "$_E_UNKNOWN_ARGUMENT"
			fi
			;;
		*)
			# shellcheck disable=SC2034
			_value_type="$2"
			error "$(translate "Argument has an invalid type for it's value: '\$_value_type'.")"
			return "$_E_UNKNOWN_ARGUMENT"
			;;
	esac

	# Check if argument type is valid
	case "$3" in
		"required"|"optional")
			true
			;;
		"identifier")
			if printf '%s' "$_ARGUMENTS" | grep -q '|identifier|'; then
				error "$(translate "Argument identifier already defined.")"
				return "$_E_UNKNOWN_ARGUMENT"
			fi
			;;
		*)
			# shellcheck disable=SC2034
			_argument_type="$3"
			error "$(translate "Argument has an invalid type: '\$_argument_type'.")"
			return "$_E_UNKNOWN_ARGUMENT"
			;;
	esac

	# Check if the default argument has the correct type
	_fails=0
	__module_is_valid_type "$2" "${6:-}" || _fails="$?"
	if [ "$_fails" -ne "0" ]; then
		_val="$6"
		_valuetype="$2"
		error "$(translate "The value '\$_val' is not of type '\$_valuetype'.")"
		return "$_E_INVALID_VALUE"
	fi

	# Save the information to a variable for __module_parse
	if [ -z "${_ARGUMENTS:-}" ]; then
		##$_ARGUMENTS all the arguments for the currently loaded module
		_ARGUMENTS="$1|$2|$3|$4|$5|${6:-}"
	else
		_ARGUMENTS="${_ARGUMENTS}$(printf '\n%s' "$1|$2|$3|$4|$5|${6:-}")"
	fi
}

module_description() {
	## Shows a description for the module in the help.
	##$1 the description

	# shellcheck disable=SC2034
	_MODULE_DESCRIPTION="$1"
}

##$ENSHURE_MODULE_PATH the path to search for modules
__module_load() {
	## Loads a module.
	##$1 the module to load.

	_module=$1
	_modpath="${ENSHURE_MODULE_PATH:-$_BASEDIR/modules}"

	if [ -f "$_modpath/${_module}.sh" ]; then
		# shellcheck disable=SC1090
		. "$_modpath/${_module}.sh"
	elif [ -f "$_modpath/$_module/main.sh" ]; then
		# shellcheck disable=SC1090
		. "$_modpath/$_module/main.sh"
	else
		error "$(translate "Could not locate module '\$_module'")"
		debug "$(translate "Module path is '\$_modpath'")" log
		return "$_E_MODULE_NOT_FOUND"
	fi

	# shellcheck disable=SC2034
	_MODULE="$_module"
}

__module_list() {
	## Lists all available modules
	##$1 prefix to prepend for each module

	_modpath="${ENSHURE_MODULE_PATH:-$_BASEDIR/modules}"
	# shellcheck disable=SC2012
	# it doesn't like the ls for non-alnum filenames, but it's something we can control
	# but improvements are always welcome
	for _mod in $(ls "$_modpath/" | sort); do
		_mod=${_mod%.sh}
		if [ -n "$_mod" ]; then
			printf '%s%s\n' "${1:-}" "$_mod"
		fi
	done
}

__module_is_valid_state() {
	## Returns 0 if the state is valid
	##$1 the state to check. Optional, if not given $_STATE is used

	_state="${1:-$_STATE}"

	printf ':%s:' "$_STATES" | grep -q ":$_state:"
}

__module_is_valid_type() {
	## Checks if a value for the argument is of the correct type
	##$1 the type: string, integer, float, boolean, enum(...)
	##$2 the value

	# The empty string is always valid
	if [ -z "$2" ]; then
		return 0
	fi

	case "$1" in
		'string')
			# A string is always valid
			return 0
			;;
		'integer')
			if printf '%s' "$2" | grep -q '^[0-9]*$'; then
				return 0
			fi
			;;
		'float')
			if printf '%s' "$2" | grep -q '^[0-9\.]*$'; then
				return 0
			fi
			;;
		'boolean')
			if [ "$2" = 'yes' ] || [ "$2" = 'no' ]; then
				return 0
			fi
			;;
		"enum"*)
			_choices="${1#enum\(}"
			_choices="${_choices%\)}"
			if printf '%s' ":${_choices}:" | grep -q ":$2:"; then
				return 0
			fi
			;;
	esac
	return 1
}

__module_parse() {
	## Parses the commandline arguments and sets the global variables for the
	## modules.

	# Check if there is an identifier
	if ! printf '%s' "$_ARGUMENTS" | cut -d'|' -f3 | grep -q '^identifier'; then
		error "$(translate "Module '\$_MODULE' does not define an identifier.")"
		return "$_E_NO_IDENTIFIER_DEFINED"
	fi

	# Loop over all possible arguments and set the default values
	for _name in $(printf '%s' "$_ARGUMENTS" | cut -d'|' -f1); do
		_def=$(printf '%s' "$_ARGUMENTS" | grep "^$_name|" | cut -d'|' -f6)
		eval "$_name=\"$_def\""
	done

	# Set the identifier
	_id_line=$(printf '%s' "$_ARGUMENTS" | grep '.*|.*|identifier|')
	_id_name=$(printf '%s' "$_id_line" | cut -d'|' -f1)
	_id_type=$(printf '%s' "$_id_line" | cut -d'|' -f2)

	_fails=0
	__module_is_valid_type "$_id_type" "$_IDENTIFIER" || _fails="$?"
	if [ "$_fails" -ne "0" ]; then
		_val="$_IDENTIFIER"
		_valuetype="$_id_type"
		error "$(translate "The value '\$_val' is not of type '\$_valuetype'.")"
		return "$_E_INVALID_VALUE"
	fi

	# Fix quotations
	_quoted_id=$(printf '%s' "$_IDENTIFIER" | sed 's/\"/\\\"/g')
	eval "${_id_name}=\"$_quoted_id\""

	# Loop over the arguments to override the given defaults
	while [ "$#" -gt 0 ]; do
		# Pop the first two arguments
		_name=$1
		_val=$2
		shift
		shift

		# Check if the name of the argument is valid
		_argument="$(printf '%s' "$_ARGUMENTS" | grep "^${_name}|")" || _argument=''
		if [ -z "$_argument" ]; then
			error "$(translate "No such argument: '\$_name'")"
			return "$_E_UNKNOWN_ARGUMENT"
		fi

		_valuetype=$(printf '%s' "$_argument" | cut -d'|' -f2)
		_argtype=$(printf '%s' "$_argument" | cut -d'|' -f3)

		# Don't allow overriding the identifier value in the options
		if [ "$_argtype" = "identifier" ]; then
			continue;
		fi

		# Check if the values are of the correct type & set the variable if so
		_fails=0
		__module_is_valid_type "$_valuetype" "$_val" || _fails="$?"
		if [ "$_fails" -ne "0" ]; then
			error "$(translate "The value '\$_val' is not of type '\$_valuetype'.")"
			return "$_E_INVALID_VALUE"
		fi
		_val=$(printf '%s' "$_val" | sed 's/\"/\\\"/g')
		eval "$_name=\"$_val\""
	done

	# Check if all required attributes are set
	for _name in $(printf '%s' "$_ARGUMENTS" | grep '.*|.*|required|' | cut -d'|' -f1); do
		require_argument "$_name"
	done
}

translated_state() {
	## Prints the translation of a state to the stdout.
	##$1 the state to translate, optional.
	##> $ translated_state present
	##> aanwezig

	##$_TRANSLATED_STATES All the possible states of the module, but translated.

	_req_state=${1:-$_STATE}

	# Find out how many states there are
	_max=$(printf '%s' "$_STATES" | tr -dc ':' | wc -c)
	_max=$(( _max + 1 ))

	# Find where the requested state is in the array
	_i=1
	_state_at=$(printf '%s' "$_STATES" | cut -d: -f$_i)
	while ! [ "$_state_at" = "$_req_state" ] && [ "$_i" -le "$_max" ]; do
		_i=$(( _i + 1 ))
		_state_at=$(printf '%s' "$_STATES" | cut -d: -f$_i)
	done

	if ! [ "$_state_at" = "$_req_state" ]; then
		# If not found just print the requested state
		printf '%s' "$_req_state"
	else
		# If found print the state in the translated array
		printf '%s' "$(printf '%s' "$_TRANSLATED_STATES" | cut -d: -f$_i)"
	fi
}

require_argument() {
	## Prints an error and returns a nonzero argument if a required argument is not
	## is not set.
	##$1 the argument that is required
	##> $ require_argument test
	##> The argument 'test' is required, but not given.
	_name=$1
	_val=$(eval "printf '%s' \"\$$_name\"")
	if [ -z "${_val:-}" ]; then
		error "$(translate "The argument '\$_name' is required, but not given.")"
		return "$_E_ARGUMENT_MISSING"
	fi
}
