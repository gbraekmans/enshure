Defined in bin/enshure
----------------------

include()
#########

Defined in ``bin/enshure``.

Makes sure source files are only included once. This prevents errors with
circular dependencies.

Arguments:

- $1, one of "core" "lib" "type" "module", followed by /filename

Example::

  include core/main
  include core/msg

Implementation::

  include() {
  	# Don't do anything if already included
  	if printf ":$_INCLUDED:" | grep ":$1:"; then
  		return
  	fi
  	# Include the file
  	. "$_BASEDIR/$1.sh"
  	# Remember the file is already included
  	if [ -z "$_INCLUDED" ]; then
  		_INCLUDED="$1"
  	else
  		_INCLUDED="${_INCLUDED}:$1"
  	fi
  }

Defined in core/error.sh
------------------------

die()
#####

Defined in ``core/error.sh``.

What happens if we can't exit cleanly on an error.

Implementation::

  die() {
  	if [ -z "${1:-}" ]; then
  		_err=$_E_GENERIC
  	else
  		_err=$1
  	fi
  	>&2 printf "CRITICAL FAILURE: ${2:-Something unknown went terribly wrong...}\n"
  	exit $_err
  }

Defined in core/msg.sh
----------------------

msg_begin()
###########

Defined in ``core/msg.sh``.

Indicates the begin of a enSHure run. Related ``__msg()``.

Implementation::

  msg_begin() {
  	__msg "BEGIN" "enSHure $_VERSION"
  }

msg_change()
############

Defined in ``core/msg.sh``.

Indicates that the system of the user has been changed. Related ``__msg()``.

Arguments:

- $1, The message displayed to the user

Implementation::

  msg_change() {
  	__msg "CHANGE" "$1"
  }

msg_debug()
###########

Defined in ``core/msg.sh``.

Notifies the user of things the developers finds useful. Related ``__msg()``.

Arguments:

- $1, The message displayed to the user

Implementation::

  msg_debug() {
  	__msg "DEBUG" "$1"
  }

msg_end()
#########

Defined in ``core/msg.sh``.

Indicates the end of a enSHure run. Related ``__msg()``.

Implementation::

  msg_end() {
  	:
  }

msg_error()
###########

Defined in ``core/msg.sh``.

Indicates something unexpected or unrecoverable has occured,
usually followed by a nonzero exit. Related ``__msg()``.

Arguments:

- $1, The message displayed to the user

Implementation::

  msg_error() {
  	__msg "ERROR" "$1"
  }

msg_info()
##########

Defined in ``core/msg.sh``.

Notifies the user of something important. Related ``__msg()``.

Arguments:

- $1, The message displayed to the user

Implementation::

  msg_info() {
  	__msg "INFO" "$1"
  }

msg_ok()
########

Defined in ``core/msg.sh``.

Indicates that no action was needed. Related ``__msg()``.

Arguments:

- $1, The message displayed to the user

Implementation::

  msg_ok() {
  	__msg "OK" "$1"
  }

msg_warning()
#############

Defined in ``core/msg.sh``.

Indicates an error was recovered or the functionality of the program is
is severely restricted by it. Related ``__msg()``.

Arguments:

- $1, The message displayed to the user

Implementation::

  msg_warning() {
  	__msg "WARNING" "$1"
  }

