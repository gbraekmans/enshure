apt_source
==========

Adds or removes an apt source
Example::

  $ enshure apt_source ftp://ftp.debian.org/debian/dists/ present

Type: generic
-------------

States:

* present (default)
* absent

Arguments
---------

* | **url**: String. Identifier.
  | The url to the repository.
  | Example: ``ftp://ftp.debian.org/debian/dists/``
* | **distro**: String. Required.
  | Name of the distribution
  | Example: ``stable``
* | **components**: String. Required.
  | Names of the components
  | Example: ``main contrib non-free``
* | **type**: Enum(deb:deb-src). Required.
  | Type of repository
  | Example: ``deb-src``
