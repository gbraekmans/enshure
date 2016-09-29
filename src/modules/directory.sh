module_type "generic"
module_description "$(translate "Creates or removes a directory.")"

argument "dir_path" string identifier "$(translate "The path to the directory.")" "/root/.bashrc"
argument "user" string optional "$(translate "The owner of the directory.")" "root"
argument "group" string optional "$(translate "The group-ownership of the directory.")" "root"
argument "mode" integer optional "$(translate "The permissions of the directory.")" "755"

is_state_present() {

	if [ ! -d "$dir_path" ]; then
		return 1
	fi

	# shellcheck disable=SC2012
	ls=$(ls -ld "$dir_path" | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf("%0o ",k);print $3, $4}')
	dir_owner=$(printf '%s' "$ls" | cut -d' ' -f2)
	dir_group=$(printf '%s' "$ls" | cut -d' ' -f3)
	dir_mode=$(printf '%s' "$ls" | cut -d' ' -f1)

	# if permissions are given and equal
	result=1
	if ([ -z "$user" ] || [ "$dir_owner" = "$user" ]) && \
	([ -z "$group" ] || [ "$dir_group" = "$group" ]) && \
	([ -z "$mode" ] || [ "$dir_mode" = "$mode" ]); then
		result=0
	fi

	return "$result"
}

is_state_absent() {
	[ ! -d "$dir_path" ]
}

attain_state_present() {
	# Create the directory
	run "rm -rf '$dir_path'"
	run "mkdir -p '$dir_path'"

	# Set permissions
	[ -n "$mode" ] && run "chmod '$mode' '$dir_path'"
	[ -n "$user" ] && run "chown '$user' '$dir_path'"
	[ -n "$group" ] && run "chgrp '$group' '$dir_path'"

	return 0
}

attain_state_absent() {
	run "rm -rf '$dir_path'"
}
