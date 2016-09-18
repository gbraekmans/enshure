module_type message
module_description "$(translate "Displays the result of a query to the user.")"

argument query string identifier "$(translate "The query to be shown.")" "summary"
argument task string optional "$(translate "If the query has an argument task, pass this value.")" "webserver"

get_message() {
	case "$query" in
		"made_change")
			if query "made_change"; then
				printf '%s' "$(translate "enSHure made a change.")"
			else
				printf '%s' "$(translate "No change made by enSHure.")"
			fi
			;;
		"current_task")
			printf "$(translate "Current task is: '%s'")" "$(query current_task)"
			;;
		"summary")
			summary="$(query summary "$task")"
			change=$(printf '%s' "$summary" | grep 'change:' | cut -d' ' -f2)
			total=$(printf '%s' "$summary" | grep 'total:' | cut -d' ' -f2)
			printf "$(translate '%s of %s statements required changes')" "$change" "$total"
			;;
		*)
			printf '%s' "$(query "$query")"
			;;
	esac
}

verify_requirements() {
	if ! printf '%s' "$_QUERIES" | grep -q "$query"; then
		error "$(translate "Query '\$query' is unknown.")"
		return 1
	fi

	if [ -n "${task:-}" ] && [ "$query" != "summary" ]; then
		error "$(translate "Can only supply the task argument with a summary query")"
		return 1
	fi
	return 0
}
