Best practices
==============

Minimize the possible damage
----------------------------

It's easy to forget your executing a shell script rather than
writing a spec-file. Harden your scripts with::

  set -o errexit
  set -o nounset
  # if using bash
  set -o pipefail

Before you execute a script you can verify all enSHure statements by setting
the environment variable ``ENSHURE_VALIDATE``.

Use tasks
---------

It's usefull for querying the log later on. You can supply a message of what
this task does. Tasks can be nested and provide you with a
clear seperation of what's been done. For example::

  enshure --task begin "webserver"

  on_exit() {
    enshure --query summary "webserver"
    enshure --task end "webserver"
  }
  trap on_exit EXIT

  enshure --task start "webserver:mysql"
  enshure package mysql installed
  enshure service mysql persistent
  enshure --task end "webserver:mysql"
  ...
.. note::

  Because you cannot start a new task when the old one is still in progress,
  means that enSHure won't continue to alter the state if a previous run with
  a cronjob failed. Maybe this is not what you want, but it still provides with
  the peace of mind knowing that a misconfigured enSHure won't continue
  filling your backup-partition with tar-archives.

Keep your sources together
--------------------------

All your files for configuring a host should be in the same directory.
Preferably this directory is also managed by git or another version control
system.

Use multiple logs
-----------------

If two scripts can run independent of one another there's no reason why they
should log to the same file. Keeping your logs short won't hurt performance and
are easier to scan through when debugging a failure.

Define common configuraton only once
------------------------------------

Try to split up configuration which is shared between hosts.
You might do something like this::

  ROLE=webserver
  enshure --task begin "$ROLE"

  . "$(dirname "$0")/tasks/ntp.sh"

  enshure --task end

with ``tasks/ntp.sh`` looking something like this::

  enshure --task begin "${ROLE}::ntp"
  ...
  enshure --task end
