symlink
=======

Creates or removes a symlink.
Example::

  $ enshure symlink /root/.bashrc present

Type: generic
-------------

States:

* present (default)
* absent

Arguments
---------

* | **sym_path**: String. Identifier.
  | The path to the symlink.
  | Example: ``/root/.bashrc``
* | **user**: String. Optional.
  | The owner of the symlink.
  | Example: ``root``
* | **group**: String. Optional.
  | The group-ownership of the symlink.
  | Example: ``root``
* | **target**: String. Optional.
  | The target of the symlink.
  | Example: ``/etc/common/bashrc``
