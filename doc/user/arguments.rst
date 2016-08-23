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

Environment variables
---------------------

Before explaining what enSHure can do, it's important to know which
environment variables influence the behaviour of the program.

- ``$ENSHURE_LOG``: this is the path to the where the log file should
  be placed.
- ``$ENSHURE_VERBOSITY``: which messages shall be displayed to the user.
  The value should be one of: ``ERROR``, ``WARNING``, ``INFO`` or ``DEBUG``


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
