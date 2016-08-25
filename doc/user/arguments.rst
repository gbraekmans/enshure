Options and arguments
=====================

.. program:: enshure

There are 2 modes in which you can invoke enSHure:

#. Query mode, enSHure queries or alters it's own state.
#. Execution mode, enSHure queries or alters the state of your operating system.

The first argument given to enSHure sets the mode, if it starts with a ``-``
enSHure will run in query mode, otherwise it will run in execution mode.
enSHure requires at least one argument to run succesfully.

**TODO: REF TO EXIT STATUS**


Query mode
----------

These are all the options available in query mode:

.. include:: help_query_mode.rst

Execution mode
--------------

Every execution has at least these 2 arguments (the module and the identifier) passed to enSHure::

  # enshure MODULE IDENTIFIER 
  $ enshure apt_package ssh

The third argument, requested state, is optional. But it's recommended to always include
it, it makes your scripts a lot more readable. Just take a look::

  $ enshure apt_package ssh installed
  # or if you want to uninstall
  $ enshure apt_package ssh removed

It's possible to have more options following the requested state. These are
module-specific. For example::

  $ enshure user apache present with_home /var/www
  # Or without the requested state
  $ enshure user apache with_home /var/www

Module
######

This argument determines what you want to do. Install an rpm-package,
deb-package, enable a service, untar an archive...

Running ``enshure --help`` will display a list of all available modules.

Identifier
##########

Every module has an identifier, for a package-module it's the package
name. For a service-module it would be the service name. Every module
declares a single piece of information as it's identifier.

To know what the identifier should be for a module, add the name of the
module to the help command. To know what the identifier for the file
module should be you'd run ``enshure --help file``.

Requested state
###############

Environment variables
---------------------

The following environment variables affect the behaviour of enshure:

- ``$ENSHURE_LOG`` sets the path to the log file.
- ``$ENSHURE_VERBOSITY`` determines which messages shall be displayed to the user.
  Should be: ``ERROR``, ``WARNING``, ``INFO`` or ``DEBUG``
