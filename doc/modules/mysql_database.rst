mysql_database
==============

Creates or removes MySQL databases
Example::

  $ enshure mysql_database wordpress present

Type: generic
-------------

States:

* present (default)
* absent

Arguments
---------

* | **db**: String. Identifier.
  | The name of the database.
  | Example: ``wordpress``
* | **login**: String. Required.
  | The name of the login user.
  | Example: ``wp``
