module_type generic
module_description "$(translate "Creates or removes MySQL users")"

argument username string identifier "$(translate "The name of the user")" "wp"
argument host string required "$(translate "The host of the user")" "localhost" "127.0.0.1"
argument login string required "$(translate "The name of the login user")" "wp" "root"


mysql='mysql --skip-column-names  --batch'

is_state_present() {
	# Check if user is present
	query="SELECT 1 FROM dual WHERE EXISTS (SELECT * FROM mysql.user WHERE CONCAT(user, '@', host) = '${username}@${host}');"
	[ -n "$($mysql --user="$login" --execute="$query")" ]
 }

is_state_absent() {
	! is_state_present
}

attain_state_present() {
	# If not exists just to be safe
	query="CREATE USER '${username}'@'${host}';"
	run "$mysql --user='$login' --execute='$query'"
}

attain_state_absent() {
	# If exists just to be safe
	query="DROP USER '${username}'@'${host}';"
	run "$mysql --user='$login' --execute='$query'"
}
