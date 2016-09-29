module_type "generic"
module_description "$(translate "Sets values in the global git configuration file")"

require git

argument "user" string identifier "$(translate "The username to set the gitconfig for.")" "jdoe"
argument "email" string optional "$(translate "The email of the user. Required for state present.")" "j.doe@example.net"
argument "name" string optional "$(translate "The name of the user. Required for state present.")" "John Doe"

is_state_present() {
	usr=$(escape "$user")
	for key in user.name user.email; do
		var=$(printf '%s' "$key" | cut -d'.' -f2)
		value=$(eval "printf '%s' \"\$$var\"")
		if [ "$value" != "$(run "git config --global --get $key" "$user" no_log)" ]; then
			return 1
		fi
	done
	return 0
}

is_state_absent() {
	if run 'test -e $HOME/.gitconfig' "$user" no_log\
	|| run 'test -e ${XDG_CONFIG_HOME:-$HOME/.config}/git/config' "$user" no_log; then
		return 1
	else
		return 0
	fi
}

attain_state_present() {
	run "git config --global user.email '$email'" "$user"
	run "git config --global user.name '$name'" "$user"
}

attain_state_absent() {
	run 'rm -rf $HOME/.gitconfig' "$user"
	run 'rm -rf ${XDG_CONFIG_HOME:-$HOME/.config}/git/config' "$user"
}

verify_requirements() {
	if [ "$_STATE" = "present" ]; then
		require_argument user
		require_argument email
	fi
}

# shellcheck disable=SC2059
message_change() {
	printf "$(translate "Git configuration for user '%s' is now %s.")" "$user" "$(translated_state)"
}

# shellcheck disable=SC2059
message_ok() {
		printf "$(translate "Git configuration for user '%s' is already %s.")" "$user" "$(translated_state)"
}
