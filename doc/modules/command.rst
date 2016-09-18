Module: command
===============

Executes a command.
Example::

  $ enshure command "touch /root/test" executed

Type: command
-------------

States:

* executed (Default)

Arguments
---------

* | **statement**: String. Identifier.
  | The statement to be executed.
  | Example: ``"touch /root/test"``
* | **creates_file**: String. Optional.
  | The path to a file, link or directory created by the command.
  | Example: ``/root/test``
