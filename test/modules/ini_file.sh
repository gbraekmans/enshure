create_ini_file() {
	cat > "$1" <<EOF
# GDM configuration storage
#
# See /usr/share/gdm/gdm.schemas for a list of available options.

[daemon]
# Enabling automatic login
AutomaticLoginEnable=false

# Enabling timed login
#  TimedLoginEnable = true
#  TimedLogin = user1
#  TimedLoginDelay = 10

# Reserving more VTs for test consoles (default is 7)
#  FirstVT = 9

[security]

[xdmcp]

[greeter]
# Only include selected logins in the greeter
# IncludeAll = false
# Include = user1,user2

[chooser]

[debug]
# More verbose logs
# Additionally lets the X server dump core if it crashes
Enable = true
EOF
}

test_ini_file() {
	TMP=$(mktemp)

	create_ini_file "$TMP"

	RESULT=$(enshure ini_file "$TMP" option "AutomaticLoginEnable" value "true" section "daemon")
	assertTrue 1 "$?"
	assertEquals 2 "CHANGE: Ini file $TMP is now present." "$RESULT"

	RESULT=$(enshure ini_file "$TMP" option "AutomaticLoginEnable" value "true" section "daemon")
	assertTrue 3 "$?"
	assertEquals 4 "OK: Ini file $TMP is already present." "$RESULT"

	RESULT=$(enshure ini_file "$TMP" option "AutomaticLogin" value "root" section "daemon")
	assertTrue 5 "$?"
	assertEquals 6 "CHANGE: Ini file $TMP is now present." "$RESULT"

	RESULT=$(enshure ini_file "$TMP" option "NotAnOption" value "delete_me")
	assertTrue 7 "$?"
	assertEquals 8 "CHANGE: Ini file $TMP is now present." "$RESULT"

	RESULT=$(enshure ini_file "$TMP" option "NotAnOption" value "delete_me")
	assertTrue 11 "$?"
	assertEquals 12 "OK: Ini file $TMP is already present." "$RESULT"

	RESULT=$(enshure ini_file "$TMP" absent option "NotAnOption")
	assertTrue 7 "$?"
	assertEquals 8 "CHANGE: Ini file $TMP is now absent." "$RESULT"

	RESULT=$(enshure ini_file "$TMP" absent option "NotAnOption")
	assertTrue 9 "$?"
	assertEquals 10 "OK: Ini file $TMP is already absent." "$RESULT"

	RESULT=$(enshure ini_file "$TMP" option "news" value "whatever" section "newsection")
	assertTrue 13 "$?"
	assertEquals 14 "CHANGE: Ini file $TMP is now present." "$RESULT"

	RESULT=$(enshure ini_file "$TMP" absent option "news" section "newsection")
	assertTrue 19 "$?"
	assertEquals 20 "CHANGE: Ini file $TMP is now absent." "$RESULT"

	RESULT=$(enshure ini_file "$TMP" absent option "news" section "newsection")
	assertTrue 21 "$?"
	assertEquals 22 "OK: Ini file $TMP is already absent." "$RESULT"

	rm -rf "$TMP"

	RESULT=$(enshure ini_file "$TMP" absent option "NotAnOption")
	assertTrue 15 "$?"
	assertEquals 16 "OK: Ini file $TMP is already absent." "$RESULT"

	RESULT=$(enshure ini_file "$TMP" option "NotAnOption" value "delete_me")
	assertTrue 17 "$?"
	assertEquals 18 "CHANGE: Ini file $TMP is now present." "$RESULT"

	rm -rf "$TMP"
}
