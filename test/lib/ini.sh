create_ini_file() {
	cat > "$1" <<EOF
example = general

[section one]
example = one
one_example = OK

[section two]
example=two
two_example = Not OK

EOF
}

test_ini_get() {
	TMP=$(mktemp)

	create_ini_file "$TMP"

	RESULT=$(ini_get "$TMP" "example")
	assertEquals 1 "example = general" "$RESULT"

	RESULT=$(ini_get "$TMP" "example" "section one")
	assertEquals 2 "example = one" "$RESULT"

	RESULT=$(ini_get "$TMP" "example" "section two")
	assertEquals 3 "example=two" "$RESULT"

	RESULT=$(ini_get "$TMP" "two_example")
	assertEquals 4 "" "$RESULT"

	RESULT=$(ini_get "$TMP" "two_example" "section two")
	assertEquals 5 "two_example = Not OK" "$RESULT"

	rm -rf "$TMP"
}

test_ini_get_value() {
	TMP=$(mktemp)

	create_ini_file "$TMP"


	RESULT=$(ini_get_value "$TMP" "example")
	assertEquals 1 "general" "$RESULT"

	RESULT=$(ini_get_value "$TMP" "two_example" "section two")
	assertEquals 2 "Not OK" "$RESULT"

	rm -rf "$TMP"
}

test_ini_delete() {
	TMP=$(mktemp)

	create_ini_file "$TMP"

	RESULT=$(ini_delete "$TMP" "example")
	assertEquals 1 "1d0
< example = general" "$RESULT"

	RESULT=$(ini_delete "$TMP" "two_example" "section two")
	assertEquals 2 "9d8
< two_example = Not OK" "$RESULT"

	rm -rf "$TMP"
}

test_ini_set_value() {
	TMP=$(mktemp)

	create_ini_file "$TMP"

	RESULT=$(ini_set_value "$TMP" "example" "test")
	assertEquals 1 "1c1
< example = general
---
> example = test" "$RESULT"

	RESULT=$(ini_set_value "$TMP" "newopt" "whatever" "section one")
	assertEquals 2 "6a7
> newopt = whatever" "$RESULT"

	rm -rf "$TMP"
}
