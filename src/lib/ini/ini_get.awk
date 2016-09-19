BEGIN {
	current_section = ""
}

/\[.*\]/ {
	current_section = $0
	gsub(/\[/, "", current_section)
	gsub(/\]/, "", current_section)
	}

{
	if (section == current_section) {
		if (match($0, "^"option) ) {
			print $0
		}
	}
}
