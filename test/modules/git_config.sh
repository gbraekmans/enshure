test_git_config() {
	stub id id_jdoe_current_user

	stub git git_config_change

	RESULT=$(enshure git_config jdoe name "John Doe" email "jdoe@example.net")
	assertTrue 1 "$?"
	assertEquals 2 "CHANGE: Git configuration for user 'jdoe' is now present." "$RESULT"

	stub git git_config_ok

	RESULT=$(enshure git_config jdoe name "John Doe" email "jdoe@example.net")
	assertTrue 3 "$?"
	assertEquals 4 "OK: Git configuration for user 'jdoe' is already present." "$RESULT"

	TMP=$(mktemp -d)
	export HOME="$TMP"
	export XDG_CONFIG_HOME="$TMP/.config"

	RESULT=$(enshure git_config jdoe absent)
	assertTrue 5 "$?"
	assertEquals 6 "OK: Git configuration for user 'jdoe' is already absent." "$RESULT"

	mkdir -p "$TMP/.config/git"
	touch "$TMP/.config/git/config"

	RESULT=$(enshure git_config jdoe absent)
	assertTrue 7 "$?"
	assertEquals 8 "CHANGE: Git configuration for user 'jdoe' is now absent." "$RESULT"

	rm -rf "$TMP"
}
