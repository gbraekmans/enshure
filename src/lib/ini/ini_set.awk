BEGIN {
	current_section = ""
	last_section = ""
	replaced = 0
}

/\[.*\]/ {
	last_section = current_section
	current_section = $0
	gsub(/\[/, "", current_section)
	gsub(/\]/, "", current_section)
	if ( last_section == section && replaced == 0)
		print option" = "value
	}

{

	if (section == current_section) {
		where = match($0, option)
		if (where == 1) {
			print option" = "value
			replaced = 1
		}
		else
			print $0
	}
	else
		print $0
}
