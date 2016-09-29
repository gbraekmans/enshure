module_type "generic"
module_description "$(translate "Creates or removes a symlink.")"

argument "sym_path" string identifier "$(translate "The path to the symlink.")" "/root/.bashrc"
argument "user" string optional "$(translate "The owner of the symlink.")" "root"
argument "group" string optional "$(translate "The group-ownership of the symlink.")" "root"
argument "target" string optional "$(translate "The target of the symlink.")" "/etc/common/bashrc"

is_state_present() {

	if [ ! -L "$sym_path" ]; then
		return 1
	fi

	# shellcheck disable=SC2012
	ls=$(ls -dl "$sym_path" | awk '{print $3, $4}')
	sym_owner=$(printf '%s' "$ls" | cut -d' ' -f1)
	sym_group=$(printf '%s' "$ls" | cut -d' ' -f2)

	# https://groups.google.com/forum/#!topic/comp.unix.shell/3s8cuwcVnTk
	# Find better way, fails if name contains '-> '
	ls=$(ls -dl "$sym_path")
	sym_target=$(printf '%s' "${ls#*-> }")

	# if permissions are given and equal
	result=1
	if ([ -z "$user" ] || [ "$sym_owner" = "$user" ]) && \
	([ -z "$group" ] || [ "$sym_group" = "$group" ]) && \
	([ -z "$target" ] || [ "$sym_target" = "$target" ]); then
		result=0
	fi

	return "$result"
}

is_state_absent() {
	[ ! -L "$sym_path" ]
}

attain_state_present() {
	# Create the symlink
	run "rm -rf '$sym_path'"
	run "ln -s '$target' '$sym_path'"

	# Set permissions
	[ -n "$user" ] && run "chown '$user' '$sym_path'"
	[ -n "$group" ] && run "chgrp '$group' '$sym_path'"

	return 0
}

attain_state_absent() {
	run "rm -rf '$sym_path'"
}

verify_requirements() {
	if [ "$_STATE" = "present" ] && [ ! -e "$target" ]; then
		error "A present state requires a valid target."
		return 1
	fi
	return 0
}
