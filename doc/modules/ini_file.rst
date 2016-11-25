ini_file
========

Sets values in an ini-file
Example::

  $ enshure ini_file /etc/gdm3/daemon.conf present

Type: generic
-------------

States:

* present (default)
* absent

Arguments
---------

* | **inifile**: String. Identifier.
  | The path to the file.
  | Example: ``/etc/gdm3/daemon.conf``
* | **option**: String. Required.
  | The name of the config key.
  | Example: ``AutomaticLoginEnable``
* | **value**: String. Optional.
  | The value of the config key.
  | Example: ``true``
* | **section**: String. Optional.
  | The section of the config key.
  | Example: ``daemon``
