BEGIN {
	FS="|"
	current_task=""
	total=0
	changes=0
}
# Set the correct task, if a new one starts
$1 == "#BEGIN" { current_task=$7; }
# Set the correct task, if it ends
$1 == "#END" {
	n=split(current_task,current_taskarr,"::")
	for (i=1;i<n;i++) {
		if ( i == 1 )
			current_task = current_taskarr[i]
		else
			current_task = current_task "::" current_taskarr[i]
	}
	if (n == 1)
		current_task = ""
}
# Increment total on OK or change, but use a filter
$1 == "#OK" || $1 == "#CHANGE" {
	if ( filtered_task == "" ) {
		total++
	}
	else {
		if ( current_task ~ "^"filtered_task ) {
			total++
		}
	}
}
# Increment change on change, but use a filter
$1 == "#CHANGE" {
	if ( filtered_task == "" ) {
		changes++
	}
	else {
		if ( current_task ~ "^"filtered_task ) {
			changes++
		}
	}
}
# Display the results in human readable form
END { 
	print "change:", changes
	print "ok:", (total - changes)
	print "total:", total
}
