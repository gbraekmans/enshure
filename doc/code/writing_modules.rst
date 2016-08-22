Writing modules
===============

**TODO: Write this**

A basic module looks something like this::

  module_type generic
  
  argument path --identifier
  argument owner
  argument group
  argument mode
  
  require touch
  require rm
  
  include lib/file
  
  ensure_state() {
  	if [ $(file_mode "$path") = "$mode" ] \
  	&& [ $(file_owner "$path") = "$owner" ] \
  	&& [ $(file_group "$path") = "$group" ]; then
  		state present
  	else
  		state absent
  	fi
  }
  
  ensure_present() {
  	run touch "$path"
  	run chown "$owner:$group" "$path"
  	run chmod "$mode" "$path"
  }
  
  ensure_absent() {
  	run rm -rf "$path"
  }
