Writing a module
================

TODO: Introduction

A simple example module
-----------------------

**TODO: Explain this step by step**

A basic module looks something like this::

  module_type common
  module_description "A module which sets attributes of files."
  
  argument path string identifier "path to the file" "/root/bash_rc"
  argument owner string optional "owner of the file, NOT the UID" "root"
  argument group string optional "group of the file, NOT the GID" "wheel"
  argument mode integer optional "permissions as a 3-digit octal value." "755"
  
  require touch
  require rm
  
  include lib/file
  
  determine_actual_state() {
	if [ ! -f "$path" ]; then
  		set_actual_state absent
  		return
  	fi
  
  	if [ $(file_mode "$path") = "$mode" ] \
  	&& [ $(file_owner "$path") = "$owner" ] \
  	&& [ $(file_group "$path") = "$group" ]; then
  		set_actual_state present
  		return
  	else
  		set_actual_state obsolete
  		return
  	fi
  }
  
  attain_state_present() {
  	run touch "$path"
  	run chown "$owner:$group" "$path"
  	run chmod "$mode" "$path"
  }
  
  attain_state_absent() {
  	run rm -rf "$path"
  }
