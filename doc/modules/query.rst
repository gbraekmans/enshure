query
=====

Displays the result of a query to the user.
Example::

  $ enshure query summary info

Type: message
-------------

States:

* error
* warning
* info (default)
* debug

Arguments
---------

* | **query**: String. Identifier.
  | The query to be shown.
  | Example: ``summary``
* | **task**: String. Optional.
  | If the query has an argument task, pass this value.
  | Example: ``webserver``
