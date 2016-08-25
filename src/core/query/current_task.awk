BEGIN { FS="|"; task="" }
$1 == "#BEGIN" { task=$7; }
$1 == "#END" {
	n=split(task,taskarr,"::")
	for (i=1;i<n;i++) {
		if ( i == 1 )
			task = taskarr[i]
		else
			task = task "::" taskarr[i]
	}
	if (n == 1)
		task = ""
}
END { print task }
