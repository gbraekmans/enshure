module_type service
module_description "$(translate "Manages systemd services.")"

argument service string identifier "$(translate "The service to be managed.")" "proftpd"

is_state_enabled() {
	systemctl is-enabled "$service" > /dev/null
}

is_state_started() {
	systemctl is-active "$service" > /dev/null
}

attain_state_restarted() {
	run "systemctl restart '$service'"
}

attain_state_started() {
	run "systemctl start '$service'"
}

attain_state_stopped() {
	run "systemctl stop '$service'"
}

attain_state_disabled() {
	run "systemctl disable '$service'"
}

attain_state_enabled() {
	run "systemctl enable '$service'"
}
