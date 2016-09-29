test_pacman() {

	stub pacman pacman_installed

	RESULT=$(enshure pacman zsh installed)
	assertTrue 1 "$?"
	assertEquals 2 "OK: Pacman zsh is already installed." "$RESULT"

	stub pacman pacman_not_installed

	RESULT=$(enshure pacman zsh installed)
	assertTrue 3 "$?"
	assertEquals 4 "CHANGE: Pacman zsh is now installed." "$RESULT"

	stub pacman pacman_installed

	RESULT=$(enshure pacman zsh latest)
	assertTrue 5 "$?"
	assertEquals 6 "OK: Pacman zsh is already latest." "$RESULT"

	RESULT=$(enshure pacman openssl installed)
	assertTrue 7 "$?"
	assertEquals 8 "OK: Pacman openssl is already installed." "$RESULT"

	RESULT=$(enshure pacman openssl latest)
	assertTrue 7 "$?"
	assertEquals 8 "CHANGE: Pacman openssl is now latest." "$RESULT"

	RESULT=$(enshure pacman openssl latest sync yes)
	assertTrue 9 "$?"
	assertEquals 10 "CHANGE: Pacman openssl is now latest." "$RESULT"

	RESULT=$(enshure pacman zsh removed)
	assertTrue 11 "$?"
	assertEquals 12 "CHANGE: Pacman zsh is now removed." "$RESULT"
}
