# shellcheck disable=SC2034
test_apt_repo() {
	_apt_sources_list_location=$(mktemp)

	RESULT=$(enshure apt_repo "http://ftp.nluug.nl/pub/os/Linux/distr/debian/" distro stretch components main)
	assertTrue 1 "$?"
	assertEquals 2 "CHANGE: Apt repo http://ftp.nluug.nl/pub/os/Linux/distr/debian/ is now present." "$RESULT"

	RESULT=$(enshure apt_repo "http://ftp.nluug.nl/pub/os/Linux/distr/debian/" distro stretch components main)
	assertTrue 3 "$?"
	assertEquals 4 "OK: Apt repo http://ftp.nluug.nl/pub/os/Linux/distr/debian/ is already present." "$RESULT"

	RESULT=$(enshure apt_repo "http://ftp.nluug.nl/pub/os/Linux/distr/debian/" absent distro stretch components main)
	assertTrue 5 "$?"
	assertEquals 6 "CHANGE: Apt repo http://ftp.nluug.nl/pub/os/Linux/distr/debian/ is now absent." "$RESULT"

	RESULT=$(enshure apt_repo "http://ftp.nluug.nl/pub/os/Linux/distr/debian/" absent distro stretch components main)
	assertTrue 7 "$?"
	assertEquals 8 "OK: Apt repo http://ftp.nluug.nl/pub/os/Linux/distr/debian/ is already absent." "$RESULT"

	rm -rf "$_apt_repos_list_location"
}
