Logging
=======

Log location
------------

The log is, by default, located at ``/var/log/enshure.log``. But this location
can be overwritten by setting the new path in the ``$ENSHURE_LOG`` environment
variable. If the value of ``$ENSHURE_LOG`` is ``-`` all log output is redirected
to the stdout.

.. warning::

  You might want to disable logging by setting ``$ENSHURE_LOG`` to ``/dev/null`` or ``-``, but
  doing so means you could never query the log again. It's recommended to
  log to a regular readable file.

Log format
----------

The log format is readable by a human, but above all it should be parsible by
machines. This format is designed to be easily parsible using ``grep`` and ``cut``.

Most of the entries in the log look like this::

	#LOGTYPE|DATE|MODULE|IDENTIFIER|REQUESTED_STATE|MESSAGE

And excerpt from a log could be this::

  #BEGIN|2016-08-04 18:42:37||||
  #OK|2016-08-04 18:42:39|apt_pkg|zsh|installed|Package zsh is installed.
  touch /home/user/.zshrc
  #RETCODE|2016-08-04 18:42:39|file|/root/.zshrc|present|0
  #CHANGED|2016-08-04 18:42:39|file|/root/.zshrc|present|File /root/.zshrc is present.
  #END|2016-08-04 18:42:39||||

.. note::

  **The log is designed to be executable by the shell.** All commands which have
  altered the machine state are recorded in the log and simply calling
  ``bash /var/log/enshure.log`` will replay all changes made to the system.
  This can be very useful for setting up clones, without wanting to install
  enSHure.

Log types
---------

BEGIN
#####

This entry is optional and marks the begin of an enSHure script. This is mainly
used for determining how many changes occured to the system this run.

END
###

This entry is optional and marks the end of an enSHure script. This is mainly
used for determining how many changes occured to the system this run.


ERROR, WARNING, INFO, DEBUG
###########################

These four log types just log the message that (might) have been written to the
console.

OK, CHANGE
##########

These messages indicate wether the state of the system has been changed.

STDOUT, STDERR, RETCODE
#######################

The message holds the location of the file to where stderr and stdout have been
written.

.. note::

  On a succesful execution, the execution logfile will be deleted, otherwise your /tmp
  directory will be full of log files.
