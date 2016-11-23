directory
=========

Creates or removes a directory.
Example::

  $ enshure directory /root/.bashrc present

Type: generic
-------------

States:

* present (default)
* absent

Arguments
---------

* | **dir_path**: String. Identifier.
  | The path to the directory.
  | Example: ``/root/.bashrc``
* | **user**: String. Optional.
  | The owner of the directory.
  | Example: ``root``
* | **group**: String. Optional.
  | The group-ownership of the directory.
  | Example: ``root``
* | **mode**: Integer. Optional.
  | The permissions of the directory.
  | Example: ``755``
