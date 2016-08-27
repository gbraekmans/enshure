Install or upgrade
==================

enSHure uses `semantic versioning`_ for it's releases. Your scripts will
keep working if the major version is equal. A script written for 1.0.0
will still work on 1.5.4.

.. _`semantic versioning`: http://semver.org/

Dependencies
------------

A POSIX-compliant operating system and shell is required.

TODO: Document GZIP/COMPRESS-dependency
TODO: Document UUENCODE/base64-dependency


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

The enSHure "binary" is found at ``src/bin/enshure``. If you want it to
be available on the system for every user run:: 

  make install

Uninstalling
------------

If you never ran ``make install`` then you should be fine with just
deleting the source directory. Otherwise just run::

  make uninstall
