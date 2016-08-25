__query_current_task() {
	awk -f "$_BASEDIR/core/query/current_task.awk" "${ENSHURE_LOG:-/var/log/enshure.log}"
}
