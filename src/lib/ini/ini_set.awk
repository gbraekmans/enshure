BEGIN {
	current_section = ""
	replaced = 0
}

# On a new section start
/\[.*\]/ {
	# If we haven't encountered the option add it
	if ( current_section == section && replaced == 0){
		print option" = "value
		replaced = 1
	}
	# Parse the new section
	current_section = $0
	gsub(/\[/, "", current_section)
	gsub(/\]/, "", current_section)
}

# On every line
{

	# If we're in the correct section
	if (section == current_section) {
		# And it's the correct option
		where = match($0, "^" option " *=")
		if (where == 1) {
			# Override the value
			print option" = "value
			replaced = 1
		}
		else
			# Leave everything be
			print $0
	}
	else
		# If we're not in the right section leave everything be
		print $0
}

END {
	# If we didn't encounter the section add it, with the option
	if (replaced == 0) {
		if (section != "") {
			print "[" section "]"
		}
		print option" = "value
	}
}
