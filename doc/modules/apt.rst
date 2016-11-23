apt
===

Installs packages using 'apt-get'.
Example::

  $ enshure apt bash installed

Type: package
-------------

States:

* latest
* installed (default)
* removed

Arguments
---------

* | **package**: String. Identifier.
  | The name of the package
  | Example: ``bash``
* | **sync**: Boolean. Required.
  | If the repositories should be synced before testing for latest
  | Example: ``yes``
