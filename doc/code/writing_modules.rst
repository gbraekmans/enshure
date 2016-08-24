Writing modules
===============

TODO: Introduction

Module types
------------

Module types implement the logic needed to go from a system in a state
to the other state. They do not implement how it must be done, just
what needs to be done. If your writing a module, much of what needs
to be written is determined by it's module type.

They also define the default requested state, if the user did not
explicitly give one.

About states
------------

There are 2 kind of states for every module:

1. Requested state: the one supplied on the command line or by the type.
2. Present state: the state the system is in.

These two state-enums might have different possible values. Take a
simplified service state for example:

- Requested states: "started", "stopped", "restarted"
- Present states: "started", "stopped"

A simple example module
-----------------------

**TODO: Explain this step by step**

A basic module looks something like this::

  module_type generic
  module_description "A module which sets attributes of files."
  
  argument path identifier "the path to the file" "/root/bash_rc"
  argument owner optional "the owner of the file, NOT the UID" "root"
  argument group optional "the group of the file, NOT the GID" "wheel"
  argument mode optional "the mode of the 3-digit octal value." "755"
  
  require touch
  require rm
  
  include lib/file
  
  # TODO: find a better name for these functions
  module_state() {
	if [ ! -f "$path" ]; then
  		set_present_state absent
  		return
  	fi
  
  	if [ $(file_mode "$path") = "$mode" ] \
  	&& [ $(file_owner "$path") = "$owner" ] \
  	&& [ $(file_group "$path") = "$group" ]; then
  		set_present_state present
  		return
  	else
  		set_present_state obsolete
  		return
  	fi
  }
  
  module_state_ensure_present() {
  	run touch "$path"
  	run chown "$owner:$group" "$path"
  	run chmod "$mode" "$path"
  }
  
  module_state_ensure_absent() {
  	run rm -rf "$path"
  }
