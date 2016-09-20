Install or upgrade
==================

enSHure uses `semantic versioning`_ for it's releases. Your scripts will
keep working as long as your on a release with the same major version.
A script written for 1.0.0 will still work on 1.1.0, but a script written
for 1.1.0 may not work on 1.0.0.

.. _`semantic versioning`: http://semver.org/

Dependencies
------------

A POSIX-compliant operating system and shell is required. And there should be
one of the following utilities available:

- ``uuencode``, as defined in the POSIX-standard. Or ``base64`` installed by the
  GNU coreutils.
- ``compress``, again as defined by POSIX, but having ``gzip`` is enough for
  enSHure.

The only utility which should be available and is not defined by POSIX is ``mktemp``.
Since this utility is more widely available than for example uuencode this should
not give you any practical problems.

From source using git
---------------------

.. note::

  Since there is no 1.X release yet, this is probably your best bet for
  the most stable sources.

This will get you the latest sources.
You can install enSHure just by cloning it's git repository::

  git clone http://github.com/gbraekmans/enshure

And you can update using the git workflow::

  git fetch origin

.. warning::

  By default you will be using the ``master`` branch of the repository.
  This is where all development occurs before a release. It might be
  stable enough for most uses, but stability can only be really expected
  from the 1.X.X releases or higher.
