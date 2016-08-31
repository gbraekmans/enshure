
test_run_sh_include() {
	
	RESULT=$(. "$_BASEDIR/core/run.sh")
	assertTrue 1 "$?"
	assertEquals 2 "" "$RESULT"
	
	is_available() { if [ "$1" = "compress" ] || [ "$1" = "gzip" ]; then return 1; fi; return 0; }
	RESULT=$(. "$_BASEDIR/core/run.sh")
	assertFalse 3 "$?"
	assertEquals 4 "ERROR: enSHure requires 'compress' to be installed." "$RESULT"

	is_available() { if [ "$1" = "compress" ]; then return 1; fi; return 0; }
	RESULT=$(. "$_BASEDIR/core/run.sh")
	assertTrue 5 "$?"
	assertEquals 6 "" "$RESULT"

	is_available() { if [ "$1" = "uuencode" ] || [ "$1" = "base64" ]; then return 1; fi; return 0; }
	RESULT=$(. "$_BASEDIR/core/run.sh")
	assertFalse 7 "$?"
	assertEquals 8 "ERROR: enSHure requires 'uuencode' to be installed." "$RESULT"

	is_available() { if [ "$1" = "uuencode" ]; then return 1; fi; return 0; }
	RESULT=$(. "$_BASEDIR/core/run.sh")
	assertTrue 9 "$?"
	assertEquals 10 "" "$RESULT"

	is_available() { if [ "$1" = "uudecode" ] || [ "$1" = "base64" ]; then return 1; fi; return 0; }
	RESULT=$(. "$_BASEDIR/core/run.sh")
	assertFalse 11 "$?"
	assertEquals 12 "ERROR: enSHure requires 'uudecode' to be installed." "$RESULT"

	is_available() { if [ "$1" = "uudecode" ]; then return 1; fi; return 0; }
	RESULT=$(. "$_BASEDIR/core/run.sh")
	assertTrue 13 "$?"
	assertEquals 14 "" "$RESULT"

	is_available() { if [ "$1" = "mktemp" ]; then return 1; fi; return 0; }
	RESULT=$(. "$_BASEDIR/core/run.sh")
	assertFalse 15 "$?"
	assertEquals 16 "ERROR: enSHure requires 'mktemp' to be installed." "$RESULT"
}

test_run_serialize() {
	EXAMPLE="$(mktemp)"

	cat > "$EXAMPLE" <<-"EOF"
	Accusamus soluta sit aut esse quis. Eius soluta accusantium placeat non sed. Sit aut qui amet fugiat quia architecto totam et. Est illo reprehenderit et dignissimos pariatur et magnam. Saepe aliquid corporis rerum animi fugit ea inventore. Soluta eos deleniti vel autem sit enim.
	Est alias quis et minima perferendis temporibus. Ratione minima id ipsum unde est. Id laborum perferendis libero ea. Beatae unde praesentium mollitia deleniti. Quas perferendis a minima commodi.
	Qui quidem et officia est incidunt. Laboriosam et eligendi natus reprehenderit praesentium maxime. Consequatur aut suscipit odit laboriosam magnam omnis aut voluptatem. Quo odit cumque harum est et ad.
	Qui rerum mollitia et delectus numquam suscipit reprehenderit excepturi. Cumque asperiores qui ut. Nesciunt voluptatem quasi odio dolores aut quis odio culpa.
	Enim qui aut saepe illum. Totam non corporis dolorum commodi tenetur ut enim dolore. Vero illo facere harum alias odio omnis quia ea.
	EOF

	# compress & uuencode unavailable
	is_available() { if [ "$1" = "compress" ] || [ "$1" = "uuencode" ]; then return 1; fi; return 0; }
	RESULT=$(__run_serialize "$EXAMPLE")
	assertTrue 7 "$?"
	assertEquals 8 "GZIP|H4sIAAAAAAAAA12TS44bMQxE9z4FT9B3SAZZDBAEmCTInlbTNgH9RpSMOX6Kku04s2y1WCw+lr6EMIzTMLISR2cy7cSjk5gJvQ+1jb7pv9887+euI1GNHIQ75ZLJZN/o160WZcRJOp3GWXl+o7KFi3YJvVAvnRNJh7R10hgLNalNLpJ3aRBB6a7nrGaailHlBpnR/DzxOXNCL5YqxFEhvlMorZamBp0GZ5w16ewOLSbNV8m9NEHZGkOgukuUrF3pKtFtS5rD4yxtBzcGcbbJYDZW/GCq0k7SYBSnKPGuxwFIP7lryXK/Bk9aDVYGRgJMzPq6U+RjcX/PIlGP0gpsbvQVNFlWSW0sJgt0KjHCKD8sb/Q2YO1Zhu+dQ0mp7Lod3rAFhyOOmsrppAES4sRz0H1kePruhrTYXAdJ1LOrUQZt+7ST/wzxhybQfCnZ5H3M3fjibVjQissw0Ne0S3xtjUrKbhU3r9hD7QyCPktZBWGk9yF0YWfkRuGJ9zXJWuyDhCcEMIL7zF4G9Uf3T2H6CFLhENReVgM2kFPkYW6XBkD8ENQCyZMx/GNTd1ZoL3Fev6Xb1mkYsTKyAu4r845g5hKZHpjs9wy6v49HQKcSJrmtCRnK4vjGSt6t00Z/PBTzaZzwytqdysrk7L5gzreF8Bz+ApK8pbnKAwAA" "$RESULT"


	if ! command -v uuencode > /dev/null; then
		startSkipping
	fi

	# Both uuencode and compress are available
	is_available() { return 0; }
	isSkipping || RESULT=$(__run_serialize "$EXAMPLE")
	assertTrue 1 "$?"
	assertEquals 2 "COMPRESS|H52QQcaMqTMnTBuCIOa8YVOHTpiEaeiACNMQRJk5c8qAiFMnzRwXIIqkQaiQocOJAgmGcUNnZBsQcNiEGVMmjEQ3b9wkLEMG5JSIEytyTDOxTRmJZuqcSWNzY8eHYeSMQROxzBg6b0BgdfjyKMgicySmYcMmq5wycM6iKeOGTBk5QI+CIJPmjBuPc9K0eTMHZlSmdOrIsSixTRi7Bn2GQasxDJs0Q8mAGPNGDpzKHkGclVPn5Uq9RJMulVgTRBo3dthiPetzYcOHZfjOLcOGbUSiqdkEpVPmZV7Sd9u4UABWomOmfYf2ldvmtN6HcN6aecuWbl/ebS7DFUMQpBSbaXJqbB78YRrJaeDM6QyiTluNF+mATCJZppjK7KPLmX62bebHYryVVU0gCVGTQxq55xZMciyWEUsugbAXWbc95FZtd7UEUhR1hNGXfvxVl9lD5D032Rtt7EXXcBwSFVlvhIHwhhlmpDEGUxaFZZobN5LhnnwgMBHGfXDxZVCMtNUlIghu2ITQWWmVsdZ7cEmUloOqRWgYHnqVAdIQOWXEkZODUSTRenPcCAdQb9AlkX2YGfmSYYi9hOJdfZkJgh2uweEQdhvWkVWbQA3UBkcaoREVe/HFGEZPCrSo2VvsTfhYS7BJdKFVgfXlRmdj+kaQmkBBqVZ1b8WFB01+CpbGl6DW0dgc+oV3VnIdtQekExfd+OOeff4J45h5yUhXVmQsVNlFuzmVGaFZDcQGHGEMV0RwzjZbEGOmkdUZSFS8wRWTOZ1oGWZ9JVsWZy9RliKhWrF1lGC6WoStusuCZIWA3ZYFghkzUQeCouxO9JiHxoYnYxt4OgtbtQoA" "$RESULT"

	# uuencode unavailable
	is_available() { if [ "$1" = "uuencode" ]; then return 1; fi; return 0; }
	isSkipping || RESULT=$(__run_serialize "$EXAMPLE")
	assertTrue 3 "$?"
	assertEquals 4 "COMPRESS|H52QQcaMqTMnTBuCIOa8YVOHTpiEaeiACNMQRJk5c8qAiFMnzRwXIIqkQaiQocOJAgmGcUNnZBsQcNiEGVMmjEQ3b9wkLEMG5JSIEytyTDOxTRmJZuqcSWNzY8eHYeSMQROxzBg6b0BgdfjyKMgicySmYcMmq5wycM6iKeOGTBk5QI+CIJPmjBuPc9K0eTMHZlSmdOrIsSixTRi7Bn2GQasxDJs0Q8mAGPNGDpzKHkGclVPn5Uq9RJMulVgTRBo3dthiPetzYcOHZfjOLcOGbUSiqdkEpVPmZV7Sd9u4UABWomOmfYf2ldvmtN6HcN6aecuWbl/ebS7DFUMQpBSbaXJqbB78YRrJaeDM6QyiTluNF+mATCJZppjK7KPLmX62bebHYryVVU0gCVGTQxq55xZMciyWEUsugbAXWbc95FZtd7UEUhR1hNGXfvxVl9lD5D032Rtt7EXXcBwSFVlvhIHwhhlmpDEGUxaFZZobN5LhnnwgMBHGfXDxZVCMtNUlIghu2ITQWWmVsdZ7cEmUloOqRWgYHnqVAdIQOWXEkZODUSTRenPcCAdQb9AlkX2YGfmSYYi9hOJdfZkJgh2uweEQdhvWkVWbQA3UBkcaoREVe/HFGEZPCrSo2VvsTfhYS7BJdKFVgfXlRmdj+kaQmkBBqVZ1b8WFB01+CpbGl6DW0dgc+oV3VnIdtQekExfd+OOeff4J45h5yUhXVmQsVNlFuzmVGaFZDcQGHGEMV0RwzjZbEGOmkdUZSFS8wRWTOZ1oGWZ9JVsWZy9RliKhWrF1lGC6WoStusuCZIWA3ZYFghkzUQeCouxO9JiHxoYnYxt4OgtbtQoA" "$RESULT"

	# compress unavailable
	is_available() { if [ "$1" = "compress" ]; then return 1; fi; return 0; }
	isSkipping || RESULT=$(__run_serialize "$EXAMPLE")
	assertTrue 5 "$?"
	assertEquals 6 "GZIP|H4sIAAAAAAAAA12TS44bMQxE9z4FT9B3SAZZDBAEmCTInlbTNgH9RpSMOX6Kku04s2y1WCw+lr6EMIzTMLISR2cy7cSjk5gJvQ+1jb7pv9887+euI1GNHIQ75ZLJZN/o160WZcRJOp3GWXl+o7KFi3YJvVAvnRNJh7R10hgLNalNLpJ3aRBB6a7nrGaailHlBpnR/DzxOXNCL5YqxFEhvlMorZamBp0GZ5w16ewOLSbNV8m9NEHZGkOgukuUrF3pKtFtS5rD4yxtBzcGcbbJYDZW/GCq0k7SYBSnKPGuxwFIP7lryXK/Bk9aDVYGRgJMzPq6U+RjcX/PIlGP0gpsbvQVNFlWSW0sJgt0KjHCKD8sb/Q2YO1Zhu+dQ0mp7Lod3rAFhyOOmsrppAES4sRz0H1kePruhrTYXAdJ1LOrUQZt+7ST/wzxhybQfCnZ5H3M3fjibVjQissw0Ne0S3xtjUrKbhU3r9hD7QyCPktZBWGk9yF0YWfkRuGJ9zXJWuyDhCcEMIL7zF4G9Uf3T2H6CFLhENReVgM2kFPkYW6XBkD8ENQCyZMx/GNTd1ZoL3Fev6Xb1mkYsTKyAu4r845g5hKZHpjs9wy6v49HQKcSJrmtCRnK4vjGSt6t00Z/PBTzaZzwytqdysrk7L5gzreF8Bz+ApK8pbnKAwAA" "$RESULT"

	# compress & gzip unavailable
	is_available() { if [ "$1" = "compress" ] || [ "$1" = "gzip" ]; then return 1; fi; return 0; }
	isSkipping || RESULT=$(__run_serialize "$EXAMPLE" 2>&1)
	assertFalse 9 "$?"
	assertEquals 10 "CRITICAL FAILURE: Could not find a supported compression command." "$RESULT"

	# uuencode & base64 unavailable
	is_available() { if [ "$1" = "uuencode" ] || [ "$1" = "base64" ]; then return 1; fi; return 0; }
	isSkipping || RESULT=$(__run_serialize "$EXAMPLE" 2>&1)
	assertFalse 11 "$?"
	assertEquals 12 "CRITICAL FAILURE: Could not find a suitable base64 implementation." "$RESULT"

	isSkipping && endSkipping

	rm -rf "$EXAMPLE"
	unset EXAMPLE
}

test_run_unserialize() {
	EXAMPLE=$(cat <<-"EOF"
	Accusamus soluta sit aut esse quis. Eius soluta accusantium placeat non sed. Sit aut qui amet fugiat quia architecto totam et. Est illo reprehenderit et dignissimos pariatur et magnam. Saepe aliquid corporis rerum animi fugit ea inventore. Soluta eos deleniti vel autem sit enim.
	Est alias quis et minima perferendis temporibus. Ratione minima id ipsum unde est. Id laborum perferendis libero ea. Beatae unde praesentium mollitia deleniti. Quas perferendis a minima commodi.
	Qui quidem et officia est incidunt. Laboriosam et eligendi natus reprehenderit praesentium maxime. Consequatur aut suscipit odit laboriosam magnam omnis aut voluptatem. Quo odit cumque harum est et ad.
	Qui rerum mollitia et delectus numquam suscipit reprehenderit excepturi. Cumque asperiores qui ut. Nesciunt voluptatem quasi odio dolores aut quis odio culpa.
	Enim qui aut saepe illum. Totam non corporis dolorum commodi tenetur ut enim dolore. Vero illo facere harum alias odio omnis quia ea.
	EOF
	)
	EX_COMPRESS="COMPRESS|H52QQcaMqTMnTBuCIOa8YVOHTpiEaeiACNMQRJk5c8qAiFMnzRwXIIqkQaiQocOJAgmGcUNnZBsQcNiEGVMmjEQ3b9wkLEMG5JSIEytyTDOxTRmJZuqcSWNzY8eHYeSMQROxzBg6b0BgdfjyKMgicySmYcMmq5wycM6iKeOGTBk5QI+CIJPmjBuPc9K0eTMHZlSmdOrIsSixTRi7Bn2GQasxDJs0Q8mAGPNGDpzKHkGclVPn5Uq9RJMulVgTRBo3dthiPetzYcOHZfjOLcOGbUSiqdkEpVPmZV7Sd9u4UABWomOmfYf2ldvmtN6HcN6aecuWbl/ebS7DFUMQpBSbaXJqbB78YRrJaeDM6QyiTluNF+mATCJZppjK7KPLmX62bebHYryVVU0gCVGTQxq55xZMciyWEUsugbAXWbc95FZtd7UEUhR1hNGXfvxVl9lD5D032Rtt7EXXcBwSFVlvhIHwhhlmpDEGUxaFZZobN5LhnnwgMBHGfXDxZVCMtNUlIghu2ITQWWmVsdZ7cEmUloOqRWgYHnqVAdIQOWXEkZODUSTRenPcCAdQb9AlkX2YGfmSYYi9hOJdfZkJgh2uweEQdhvWkVWbQA3UBkcaoREVe/HFGEZPCrSo2VvsTfhYS7BJdKFVgfXlRmdj+kaQmkBBqVZ1b8WFB01+CpbGl6DW0dgc+oV3VnIdtQekExfd+OOeff4J45h5yUhXVmQsVNlFuzmVGaFZDcQGHGEMV0RwzjZbEGOmkdUZSFS8wRWTOZ1oGWZ9JVsWZy9RliKhWrF1lGC6WoStusuCZIWA3ZYFghkzUQeCouxO9JiHxoYnYxt4OgtbtQoA"	
	EX_GZIP="GZIP|H4sIAAAAAAAAA12TS44bMQxE9z4FT9B3SAZZDBAEmCTInlbTNgH9RpSMOX6Kku04s2y1WCw+lr6EMIzTMLISR2cy7cSjk5gJvQ+1jb7pv9887+euI1GNHIQ75ZLJZN/o160WZcRJOp3GWXl+o7KFi3YJvVAvnRNJh7R10hgLNalNLpJ3aRBB6a7nrGaailHlBpnR/DzxOXNCL5YqxFEhvlMorZamBp0GZ5w16ewOLSbNV8m9NEHZGkOgukuUrF3pKtFtS5rD4yxtBzcGcbbJYDZW/GCq0k7SYBSnKPGuxwFIP7lryXK/Bk9aDVYGRgJMzPq6U+RjcX/PIlGP0gpsbvQVNFlWSW0sJgt0KjHCKD8sb/Q2YO1Zhu+dQ0mp7Lod3rAFhyOOmsrppAES4sRz0H1kePruhrTYXAdJ1LOrUQZt+7ST/wzxhybQfCnZ5H3M3fjibVjQissw0Ne0S3xtjUrKbhU3r9hD7QyCPktZBWGk9yF0YWfkRuGJ9zXJWuyDhCcEMIL7zF4G9Uf3T2H6CFLhENReVgM2kFPkYW6XBkD8ENQCyZMx/GNTd1ZoL3Fev6Xb1mkYsTKyAu4r845g5hKZHpjs9wy6v49HQKcSJrmtCRnK4vjGSt6t00Z/PBTzaZzwytqdysrk7L5gzreF8Bz+ApK8pbnKAwAA"

	if ! command -v uudecode > /dev/null; then
		startSkipping
	fi

	# All are available
	is_available() { return 0; }
	isSkipping || RESULT=$(__run_unserialize "$EX_GZIP")
	assertTrue 1 "$?"
	assertEquals 2 "$EXAMPLE" "$RESULT"

	isSkipping || RESULT=$(__run_unserialize "$EX_COMPRESS")
	assertTrue 3 "$?"
	assertEquals 4 "$EXAMPLE" "$RESULT"

	isSkipping && endSkipping

	if ! command -v base64 > /dev/null; then
		startSkipping
	fi

	# uudecode unavailable
	is_available() { if [ "$1" = "uudecode" ]; then return 1; fi; return 0; }

	isSkipping || RESULT=$(__run_unserialize "$EX_GZIP")
	assertTrue 5 "$?"
	assertEquals 6 "$EXAMPLE" "$RESULT"

	if ! command -v uncompress > /dev/null; then
		startSkipping
	fi

	isSkipping || RESULT=$(__run_unserialize "$EX_COMPRESS")
	assertTrue 7 "$?"
	assertEquals 8 "$EXAMPLE" "$RESULT"

	isSkipping && endSkipping

	if ! command -v uncompress > /dev/null; then
		startSkipping
	fi

	# gzip unavailable
	is_available() { if [ "$1" = "gzip" ]; then return 1; fi; return 0; }

	isSkipping || RESULT=$(__run_unserialize "$EX_GZIP")
	assertFalse 9 "$?"
	assertEquals 10 "ERROR: enSHure requires 'gzip' to be installed." "$RESULT"

	isSkipping || RESULT=$(__run_unserialize "$EX_COMPRESS")
	assertTrue 11 "$?"
	assertEquals 12 "$EXAMPLE" "$RESULT"

	isSkipping && endSkipping

	if ! command -v gzip > /dev/null; then
		startSkipping
	fi
	if ! command -v uudecode > /dev/null; then
		startSkipping
	fi

	# uncompress unavailable
	is_available() { if [ "$1" = "uncompress" ]; then return 1; fi; return 0; }

	isSkipping || RESULT=$(__run_unserialize "$EX_GZIP")
	assertTrue 13 "$?"
	assertEquals 14 "$EXAMPLE" "$RESULT"

	isSkipping || RESULT=$(__run_unserialize "$EX_COMPRESS")
	assertFalse 15 "$?"
	assertEquals 16 "ERROR: enSHure requires 'uncompress' to be installed." "$RESULT"

	isSkipping && endSkipping

	isSkipping || RESULT=$(__run_unserialize "XZ|whatever==")
	assertFalse 17 "$?"
	assertEquals 18 "ERROR: The header 'XZ' is unknown for unserialization." "$RESULT"

	is_available() { if [ "$1" = "uudecode" ] || [ "$1" = "base64" ]; then return 1; fi; return 0; }
	isSkipping || RESULT=$(__run_unserialize "$EX_COMPRESS" 2>&1)
	assertFalse 19 "$?"
	assertEquals 20 "CRITICAL FAILURE: Could not find a suitable base64 implementation." "$RESULT"

	unset EXAMPLE
	unset EX_COMPRESS
	unset EX_GZIP
}

test_run_current_shell() {
	RESULT=$(__run_current_shell)
	printf 'sh:bash:dash:ksh:mksh:zsh' | grep "${RESULT#/bin/}" > /dev/null
	assertTrue 1 "$?"
}

test_run() {
	run 'printf "This is a test"'
	assertTrue 1 "$?"
	assertEquals 2 "This is a test" "$(__run_unserialize "$(tail -n1 "$ENSHURE_LOG" | grep '^#STDOUT' | cut -d'|' -f7-)")"

	run 'printf "This is a stderr test" >&2'
	assertTrue 3 "$?"
	assertEquals 4 "This is a stderr test" "$(__run_unserialize "$(tail -n1 "$ENSHURE_LOG" | grep '^#STDERR' | cut -d'|' -f7-)")"

	run 'exit 45'
	assertFalse 5 "$?"
	assertEquals 6 "45" "$(tail -n1 "$ENSHURE_LOG" | grep '^#RETURN' | cut -d'|' -f7-)"

	mktemp() { return 1; }
	RESULT="$(run 'printf "This is a test"' 2>&1)"
	assertFalse 7 "$?"
	assertEquals 8 "CRITICAL FAILURE: Could not create temporary file." "$RESULT"
	unset -f mktemp
}
