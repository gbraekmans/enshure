module_type generic
module_description "$(translate "Creates or removes MySQL users")"

argument username string identifier "$(translate "The name of the user")" "wp"
argument host string required "$(translate "The host of the user")" "localhost" "127.0.0.1"
argument password string optional "$(translate "The password of the user")" "s3cr3t"
argument login string required "$(translate "The name of the login user")" "wp" "root"

mysql='mysql --skip-column-names  --batch'

is_state_present() {
	# Check if user is present
	query="SELECT 1 FROM mysql.user WHERE user = '${username}' AND  host = '${host}'"
	# if a password is set, add it as an extra check
	if [ -n "$password" ]; then
		query="$query AND password = PASSWORD('$password')"
	fi
	query="$query LIMIT 1;"

	if [ -z "$($mysql --user="$login" --execute="$query")" ]; then
		return 1
	fi
	return 0
 }

is_state_absent() {
	query="SELECT 1 FROM mysql.user WHERE user = '${username}' AND  host = '${host}' LIMIT 1;"
	[ -z "$($mysql --user="$login" --execute="$query")" ]
}

attain_state_present() {
	query="SELECT 1 FROM mysql.user WHERE user = '${username}' AND  host = '${host}' LIMIT 1;"
	if [ -z "$($mysql --user="$login" --execute="$query")" ]; then
		query="CREATE USER '${username}'@'${host}';"
		run "$mysql --user=\"$login\" --execute=\"$query\""
	fi

	if [ -n "$password" ]; then
		query="SET PASSWORD FOR '$username'@'$host' = PASSWORD('$password');"
		run "$mysql --user=\"$login\" --execute=\"$query\""
	fi
}

attain_state_absent() {
	query="DROP USER '${username}'@'${host}';"
	run "$mysql --user=\"$login\" --execute=\"$query\""
}
