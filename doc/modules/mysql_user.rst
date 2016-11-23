mysql_user
==========

Creates or removes MySQL users
Example::

  $ enshure mysql_user wp present

Type: generic
-------------

States:

* present (default)
* absent

Arguments
---------

* | **username**: String. Identifier.
  | The name of the user.
  | Example: ``wp``
* | **host**: String. Required.
  | The host of the user.
  | Example: ``localhost``
* | **password**: String. Optional.
  | The password of the user.
  | Example: ``s3cr3t``
* | **login**: String. Required.
  | The name of the login user.
  | Example: ``wp``
