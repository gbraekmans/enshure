module_type generic
module_description "$(translate "Creates or removes MySQL databases")"

argument db string identifier "$(translate "The name of the database")" "wordpress"
argument user string required "$(translate "Teh name of the user")" "wp" "root"


mysql='mysql --skip-column-names  --batch'

is_state_present() {
	# Check if database is present
	query='SHOW DATABASES;'
	if ! run "$mysql --user='$user' --execute='$query'" "" no_log | grep -q "^$db\$"; then
		return 1
	fi
	return 0
 }

is_state_absent() {
	# Check if database is absent
	query='SHOW DATABASES;'
	if run "$mysql --user='$user' --execute='$query'" "" no_log | grep -q "^$db\$"; then
		return 1
	fi
	return 0
}

attain_state_present() {
	# If not exists just to be safe
	query="CREATE DATABASE IF NOT EXISTS \`$db\`;"
	run "$mysql --user='$user' --execute='$query'"
}

attain_state_absent() {
	# If exists just to be safe
	query="DROP DATABASE IF EXISTS \`$db\`;"
	run "$mysql --user='$user' --execute='$query'"
}
