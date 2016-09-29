git_config
==========

Sets values in the global git configuration file
Example::

  $ enshure git_config jdoe present

Type: generic
-------------

States:

* present (default)
* absent

Arguments
---------

* | **user**: String. Identifier.
  | The username to set the gitconfig for.
  | Example: ``jdoe``
* | **email**: String. Optional.
  | The email of the user. Required for state present.
  | Example: ``j.doe@example.net``
* | **name**: String. Optional.
  | The name of the user. Required for state present.
  | Example: ``John Doe``
