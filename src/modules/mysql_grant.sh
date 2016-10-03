module_type generic
module_description "$(translate "Manages permissions for users on databases")"

argument username string identifier "$(translate "The name for the user.")" "wp"
argument host string required "$(translate "The host of the user.")" "localhost" "127.0.0.1"
argument login string required "$(translate "The name of the login user.")" "wp" "root"
argument db string required "$(translate "The name of the database.")" "wordpress"
argument permissions 'enum(read:write:all)' optional "$(translate "Which statements to grant, if state is present. If state is absent all permissions are removed.")" "read" "all"
argument with_grant boolean required "$(translate "If the user can grant other users the same privileges.")" "no" "no"


mysql='mysql --skip-column-names  --batch'

is_state_present() {
	perms=""
	case "$permissions" in
		"read")
			perms="SELECT"
			;;
		"write")
			perms="SELECT, INSERT, UPDATE, DELETE"
			;;
		"all")
			perms="ALL PRIVILEGES"
			;;
	esac

	grp="GRANT.*$perms.*ON.*$db.*"
	if [ "$with_grant" = "yes" ]; then
		grp="${grp}.*WITH.*GRANT.*OPTION.*"
	fi

	show_grants="SHOW GRANTS FOR '$username'@'$host';"
	$mysql --user="$login" --execute="$show_grants" | grep -q "^${grp}"
}

is_state_absent() {
	show_grants="SHOW GRANTS FOR '$username'@'$host';"
	# shellcheck disable=SC2143
	[ -z "$($mysql --user="$login" --execute="$show_grants" | grep -v "^GRANT USAGE" | grep -v "^GRANT PROXY")" ]
}

attain_state_present() {
	perms=""
	case "$permissions" in
		"read")
			perms="SELECT"
			;;
		"write")
			perms="SELECT, UPDATE, INSERT, DELETE"
			;;
		"all")
			perms="ALL PRIVILEGES"
			;;
	esac

	query="GRANT $perms ON \\\`$db\\\`.* TO '$username'@'$host'"

	if [ "$with_grant" = "yes" ]; then
		query="$query WITH GRANT OPTION"
	fi
	run "$mysql --user=\"$login\" --execute=\"$query\""
}

attain_state_absent() {
	query="REVOKE GRANT OPTION ON $db.* FROM '$username'@'$host';"
	run "$mysql --user=\"$login\" --execute=\"$query\""
	query="REVOKE ALL ON $db.* FROM '$username'@'$host';"
	run "$mysql --user=\"$login\" --execute=\"$query\""
}
