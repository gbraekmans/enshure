test_systemd() {

	stub systemctl systemctl_disabled

	RESULT=$(enshure systemd sshd)
	assertTrue 1 "$?"
	assertEquals 2 "CHANGE: Systemd sshd is now available." "$RESULT"

	stub systemctl systemctl_enabled

	RESULT=$(enshure systemd sshd)
	assertTrue 3 "$?"
	assertEquals 4 "OK: Systemd sshd is already available." "$RESULT"

	RESULT=$(enshure systemd sshd restarted)
	assertTrue 5 "$?"
	assertEquals 6 "CHANGE: Systemd sshd is now restarted." "$RESULT"

	RESULT=$(enshure systemd sshd unavailable)
	assertTrue 7 "$?"
	assertEquals 8 "CHANGE: Systemd sshd is now unavailable." "$RESULT"
}
