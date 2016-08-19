#!/usr/bin/env python3

import sys

with open(sys.argv[1], 'r') as f:
	all_help = f.read().strip()

for help in all_help.split("\n"):
	help = help.split("|")
	res = "\n.. option:: %s, %s\n\n  %s" % (help[1], help[2], help[3])
	print(res)
