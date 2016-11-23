mysql_grant
===========

Manages permissions for users on databases
Example::

  $ enshure mysql_grant wp present

Type: generic
-------------

States:

* present (default)
* absent

Arguments
---------

* | **username**: String. Identifier.
  | The name for the user.
  | Example: ``wp``
* | **host**: String. Required.
  | The host of the user.
  | Example: ``localhost``
* | **login**: String. Required.
  | The name of the login user.
  | Example: ``wp``
* | **db**: String. Required.
  | The name of the database.
  | Example: ``wordpress``
* | **permissions**: Enum(read:write:all). Optional.
  | Which statements to grant, if state is present. If state is absent all permissions are removed.
  | Example: ``read``
* | **with_grant**: Boolean. Required.
  | If the user can grant other users the same privileges.
  | Example: ``no``
