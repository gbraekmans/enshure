command
=======

Executes a command.
Example::

  $ enshure command "touch /root/test" executed

Type: command
-------------

States:

* executed (default)

Arguments
---------

* | **statement**: String. Identifier.
  | The statement to be executed.
  | Example: ``"touch /root/test"``
* | **creates_path**: String. Optional.
  | The path to a file, link or directory created by the command.
  | Example: ``/root/test``
