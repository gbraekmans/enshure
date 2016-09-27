module_type "generic"
module_description "$(translate "Creates or removes a file.")"

# I just called this $path originally but, apperently it doen't matter for zsh if it's PATH or path ???
argument "file_path" string identifier "$(translate "The path to the file.")" "/root/.bashrc"
argument "user" string optional "$(translate "The owner of the file.")" "root"
argument "group" string optional "$(translate "The group-ownership of the file.")" "root"
argument "mode" integer optional "$(translate "The permissions of the file.")" "755"
argument "content" string optional "$(translate "The content of the file as printed by printf.")" "Hello World\n"
argument "source_file" string optional "$(translate "Use the content of a local file.")" "/root/hello_world.txt"
argument "source_url" string optional "$(translate "Use the content of a file available by URL.")" "http://example.net/hello_world.html"

require mktemp

is_state_present() {

	if [ ! -f "$file_path" ]; then
		return 1
	fi

	# Don't know where I've found the statement, but it's pretty nifty.
	# shellcheck disable=SC2012
	ls=$(ls -l "$file_path" | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf("%0o ",k);print $3, $4}')
	file_owner=$(printf '%s' "$ls" | cut -d' ' -f2)
	file_group=$(printf '%s' "$ls" | cut -d' ' -f3)
	file_mode=$(printf '%s' "$ls" | cut -d' ' -f1)

	if [ -n "$content" ] || [ -n "$source_file" ] || [ -n "$source_url" ]; then
		tmp=$(mktemp)
	fi

	# Get the content in a temp file
	if [ -n "$content" ]; then
		# shellcheck disable=SC2059
		printf "$content" > "$tmp";
	elif [ -n "$source_file" ]; then
		cp "$source_file" "$tmp"
	elif [ -n "$source_url" ]; then
		# TODO: Improve this method using something like this http://blog.yjl.im/2012/03/downloading-only-when-modified-using.html
		wget -q "$source_url" -O "$tmp"
	fi

	# if permissions are given and equal, and if content is given and equal
	result=1
	if [ -f "$file_path" ] && \
	([ -z "$user" ] || [ "$file_owner" = "$user" ]) && \
	([ -z "$group" ] || [ "$file_group" = "$group" ]) && \
	([ -z "$mode" ] || [ "$file_mode" = "$mode" ]) && \
	([ -z "${tmp:-}" ] || diff "$tmp" "$file_path" > /dev/null ) then
		result=0
	fi

	if [ -n "$tmp" ]; then
		rm -rf "$tmp"
	fi

	return "$result"
}

is_state_absent() {
	[ ! -f "$file_path" ]
}

attain_state_present() {
	# Create the file
	mkdir -p "$(dirname "$file_path")"
	touch "$file_path"

	# shellcheck disable=SC2012
	file_mode=$(ls -l "$file_path" | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf("%0o",k)}')

	# Make the file writeable
	chmod 600 "$file_path"

	# Get the correct content in the file
	if [ -n "$content" ]; then

		# shellcheck disable=SC2059
		printf "$content" > "$file_path"
	elif [ -n "$source_file" ]; then
		cp "$source_file" "$file_path"
	elif [ -n "$source_url" ]; then
		wget -q "$source_url" -O "$file_path"
	fi

	# Restore original permissions
	chmod "$file_mode" "$file_path"

	# Set permissions
	[ -n "$mode" ] && chmod "$mode" "$file_path"
	[ -n "$user" ] && chown "$user" "$file_path"
	[ -n "$group" ] && chgrp "$group" "$file_path"

	return 0
}

attain_state_absent() {
	rm -rf "$file_path"
}

verify_requirements() {
	# Count how many of the arguments were set
	cnt=0
	for i in "$content" "$source_file" "$source_url"; do
		if [ -n "$i" ]; then
			cnt=$(( cnt + 1 ))
		fi
	done

	# Error if more than 1
	if [ "$cnt" -gt 1 ]; then
		error "$(translate "You can set only one of content, source_file or source_url")"
		return 1
	# Require wget if content is url
	elif [ "$cnt" -eq 1 ] &&  [ -n "$source_url" ]; then
		require wget
	fi

	return 0
}
