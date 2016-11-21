test_apt() {

	stub apt-get apt_installed
	stub dpkg-query dpkg_installed

	RESULT=$(enshure apt bash installed)
	assertTrue 1 "$?"
	assertEquals 2 "OK: Apt bash is already installed." "$RESULT"

	RESULT=$(enshure apt telnet installed)
	assertTrue 3 "$?"
	assertEquals 4 "OK: Apt telnet is already installed." "$RESULT"

	RESULT=$(enshure apt telnet latest sync yes)
	assertTrue 5 "$?"
	assertEquals 6 "CHANGE: Apt telnet is now latest." "$RESULT"

	stub apt-get apt_not_installed
	stub dpkg-query dpkg_not_installed

	RESULT=$(enshure apt zsh installed)
	assertTrue 7 "$?"
	assertEquals 8 "CHANGE: Apt zsh is now installed." "$RESULT"

	stub apt-get apt_zsh_installed
	stub dpkg-query dpkg_zsh_installed

	RESULT=$(enshure apt zsh removed)
	assertTrue 9 "$?"
	assertEquals 10 "CHANGE: Apt zsh is now removed." "$RESULT"
}
