module_type "archive"
module_description "$(translate "Extracts tar archives. Uses compression according to filename.")"

argument "archive_path" string identifier "$(translate "The path to the archive.")" "/tmp/wordpress.tar.gz"
argument "directory" string required "$(translate "What should be compressed, or where to extract.")" "/root"

is_state_compressed() {
	[ -e "$archive_path" ]
}

is_state_extracted() {
	[ -d "$directory" ]
}

attain_state_extracted() {
	run "mkdir -p '$directory'"
	run "tar axf '$archive_path' -C '$directory'"
}

attain_state_compressed() {
	run "(cd '$directory' && tar acf '$archive_path' .)"
}
