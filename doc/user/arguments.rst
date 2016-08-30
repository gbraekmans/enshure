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

General info
############

.. option:: -h [MODULE], --help [MODULE]

  If MODULE is empty, show a help message and exit. Otherwise show help for the module MODULE.

.. option:: -v, --version

  Print the version of enSHure and exit.

Tasks
#####

.. option:: -t ACTION [NAME], --task ACTION [NAME]

  begins or ends a task. ACTION is 'begin' or 'end'. NAME is required for a begin-action,
  but **may not** be given for an end-action.

Tasks group a sequence of enshure statements. These are usefull for a
lot of things:

1. Generating summaries of how many changes were made
2. Making sure the same script doesn't run twice
3. Self-documenting your scripts
4. Pretty printing a header

A task can be any alphanumeric name you give it. For example::

  # A simple task for grouping all mysql related things
  $ enshure --task begin "mysql"
  ...
  $ enshure --task end
  
  # But they can be nested using the ::-operator
  $ enshure --task begin "mysql"
  $ enshure --task begin "mysql::my.cnf"
  ...
  $ enshure --task end
  $ enshure --task begin "mysql::backup"
  ...
  $ enshure --task end
  $ enshure --task end

.. warning::

  You cannot begin another task while the current one is not ended.
  This may seem frustrating for scripts that tend to fail or
  while developing. But if you use a trap-statement_ it's easy
  enough to clean up.

.. _trap-statement: http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_12_02.html

Queries
#######

.. option:: -q NAME [ARGS], --query NAME [ARGS]

  Runs the query NAME with arguments ARGS.

Currently these queries are supported

- ``current_task``: Displays the current task.
- ``made_change``: Returns 0, true, if the last enshure invocation made a
  change. Returns 1 if everything was OK, 2 if we couldn't determine
  wether a change had been made (the log file is empty for example).
- ``summary``: Prints a summary of the changes on the system. You can,
  optionally add a task to filter the results. For example:
  ``summary webserver`` or ``summary webserver::mysql``.

.. note::

  The output of the queries is not formatted, so that it can be used
  in variables. If you want to print a query it might be better
  to use the ``query`` or the ``message`` module.
  
TODO: Link to the corresponding modules.

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

Every module has a type, and there are 4 possible module types. The type
of the module defines what states you can request of the module. These
are the 4 module-types and their states:

1. Command: succeeds or fails
2. Generic: present or absent
3. Package: installed, removed or latest
4. Service: always, never, started, stopped, restarted, enabled or disabled

Custom arguments
################

TODO: write this

Environment variables
---------------------

The following environment variables affect the behaviour of enshure:

- ``$ENSHURE_LOG`` sets the path to the log file.
- ``$ENSHURE_VERBOSITY`` determines which messages shall be displayed to the user.
  Should be one of:

  * ``ERROR``
  * ``WARNING``
  * ``INFO`` 
  * ``DEBUG``

- ``$ENSHURE_VALIDATE`` if this is set, then no actions will be run. enSHure
  will just validate all input given and then stop processing. Usefull if
  you want to make sure all your states and arguments are correct.
- ``$ENSHURE_MODULE_PATH`` A ``:``- seperated list of where to search
  for extra modules.
