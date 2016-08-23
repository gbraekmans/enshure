Invoking enSHure
================

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

These are all the options available in introspection mode.

.. include:: help_query_mode.rst

Execution mode
--------------

Every execution has at least these 3 arguments passed to enSHure::

  # enshure TYPE|MODULE IDENTIFIER REQUESTED_STATE
  # For example, with a type:
  $ enshure package ssh installed
  # And with a module
  $ enshure apt_package ssh installed

It's possible to have more options following the statement. These are not required
and implemented by the module. For example::

  $ enshure user apache present with_home /var/www

Environment variables
---------------------

The following environment variables affect the behaviour of enshure:

- ``$ENSHURE_LOG``sets the path to the log file.
- ``$ENSHURE_VERBOSITY`` determines which messages shall be displayed to the user.
  The value should be one of: ``ERROR``, ``WARNING``, ``INFO`` or ``DEBUG``
