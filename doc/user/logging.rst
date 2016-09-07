Understanding the log
=====================

Log location
------------

The log is, by default, located at ``/var/log/enshure.log``. But this location
can be overwritten by setting a new path in ``$ENSHURE_LOG``. If the
value of ``$ENSHURE_LOG`` is ``-`` all log output is redirected
to the stdout.

.. warning::

  You might want to disable logging by setting ``$ENSHURE_LOG`` to ``/dev/null`` or ``-``, but
  doing so means you could never query the log again. This means that taks
  are not supported, nor the output of a command would be retrievable.
  It's strongly encouraged to log to a regular readable file.

Log format
----------

The log format is readable by a human, but above all parsible by
machines. This format is designed to be easily parsible using ``grep`` and ``cut`` or ``awk``.

Most of the entries in the log look like this::

	#LOGTYPE|USER_ID|DATE|MODULE|IDENTIFIER|REQUESTED_STATE|MESSAGE

And this is an example excerpt::

  #BEGIN|0|2016-08-04 18:42:37||||zsh
  #OK|0|2016-08-04 18:42:39|apt_pkg|zsh|installed|Package zsh is present.
  touch /home/user/.zshrc
  #RETCODE|0|2016-08-04 18:42:39|file|/root/.zshrc|present|0
  #CHANGE|0|2016-08-04 18:42:39|file|/root/.zshrc|present|File /root/.zshrc is present, was absent.
  #END|0|2016-08-04 18:42:39||||

**The log is designed to be executable by the shell.** All commands which have
altered the machine state are recorded in the log and simply calling
``bash /var/log/enshure.log`` will replay all changes made to the system.
This can be very useful for setting up clones, without wanting to install
enSHure.

Log types
---------

BEGIN
#####

This entry is optional and marks the begin of a task. The message field
contains the name of the task.


END
###

This entry is optional and marks the end of a task.


ERROR, WARNING, INFO, DEBUG
###########################

These four log types just log the message that (might) have been written to the
console.

OK, CHANGE
##########

These messages indicate wether the state of the system has been changed.

RETCODE
#######

RETCODE stores the return code of command that has been executed. It is
always available as proof the command did execute.


STDOUT, STDERR
###############

A STDOUT field looks like this::

  #STDOUT|0|1970-01-01 00:00:00|file|/root/.zshrc|present|POSIX|...
  #STDOUT|0|1970-01-01 00:00:00|file|/root/.zshrc|present|GZIP|...

By default the format of compression is POSIX-compatible: everything has
been zipped with ``compress``

.. note::

  POSIX-compliance is fading from the default minimal installs of most
  Linux-distributions. Therefore the second GZIP record has been created
  because these distro's do not ship ``uuencode`` or ``compress``.
  ``gzip`` and ``base64`` are shipped in most distributions.

These entries store the base64 encoded gzipped string of
the output to the file descriptor.
Not every command has these entries, if there was **no output on the file
descriptor, no log entry** is created for that file descriptor.
If the message is, for example ``GZIP|H4sIABrNvFcAA8tIzcnJVyjPL8pJAQCFEUoNCwAAAA==`` then it could be
decoded on linux systems using something like this::

  $ printf 'H4sIABrNvFcAA8tIzcnJVyjPL8pJAQCFEUoNCwAAAA==' | base64 -d | gunzip
  hello world

.. note::

  As seen in the example above, gzipping the output does add some extra
  bytes if the ouput is small, but the real gains are to be made when
  there is lots of output.
