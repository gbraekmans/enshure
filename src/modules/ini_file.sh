module_type "generic"
module_description "$(translate "Sets values in an ini-file")"

include lib/ini

argument inifile string identifier "$(translate "The path to the file.")" "/etc/gdm3/daemon.conf"
argument option string required "$(translate "The name of the config key.")" "AutomaticLoginEnable"
argument value string optional "$(translate "The value of the config key.")" "true"
argument section string optional "$(translate "The section of the config key.")" "daemon"


is_state_present() {
	# If the file does not exist, it's not present
	if [ ! -e "$inifile" ]; then
		return 1
	fi

	# If there's a section
	if [ -n "$section" ]; then
		# The file must have the section
		ini_has_section "$inifile" "$section" || return 1

		# If the option has the value, OK, otherwise not
		if [ "$(ini_get_value "$inifile" "$option" "$section")" = "$value" ]; then
			return 0
		fi
		return 1
	else
	# If there's no section, just check the value
		if [ "$(ini_get_value "$inifile" "$option")" = "$value" ]; then
			return 0
		fi
		return 1
	fi
}

is_state_absent() {
	# If the file does not exist, it's config item is absent
	if [ ! -e "$inifile" ]; then
		return 0
	fi

	# If there's a section
	if [ -n "$section" ]; then
		# The file must have the section
		ini_has_section "$inifile" "$section" || return 1

		# If there's no option, OK, otherwise not
		if [ -z "$(ini_get "$inifile" "$option" "$section")" ]; then
			return 0
		fi
		return 1
	else
	# If there's no section, just check the option
		if [ -z "$(ini_get "$inifile" "$option" "$section")" ]; then
			return 0
		fi
		return 1
	fi
}

attain_state_present() {
	touch "$inifile"

	if [ -n "$section" ]; then
		run "printf '$(ini_set_value "$inifile" "$option" "$value" "$section")\n' | patch '$inifile'"
	else
		run "printf '$(ini_set_value "$inifile" "$option" "$value")\n' | patch '$inifile'"
	fi
}

attain_state_absent() {
	if [ -n "$section" ]; then
		run "printf '$(ini_delete "$inifile" "$option" "$section")\n' | patch '$inifile'"
	else
		run "printf '$(ini_delete "$inifile" "$option")\n' | patch '$inifile'"
	fi
	# TODO: Remove empty section?
}

# shellcheck disable=SC2059
message_change() {
	printf "$(translate "In INI file '%s' option '%s' is now %s.")" "$inifile" "$option" "$(translated_state)"
}

# shellcheck disable=SC2059
message_ok() {
	printf "$(translate "In INI file '%s' option '%s' is already %s.")" "$inifile" "$option" "$(translated_state)"
}
