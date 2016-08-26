BEGIN { FS="|"; last_action = "" }
$1 == "#OK" { last_action = "OK" }
$1 == "#CHANGE" { last_action = "CHANGE" }
$1 == "#ERROR" { last_action = "" }
END { print last_action }
