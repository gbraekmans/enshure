Testing a module
================

TODO: Write this

.. _shunit2: https://github.com/kward/shunit2
.. _ShellCheck: http://www.shellcheck.net/
.. _kcov: https://github.com/SimonKagstrom/kcov

The minimal test suite
----------------------

You'd use this for getting stuff up and running quickly. Eventually all
code should be tested using the extensive test suite, but it's better
to do something now and have it tested than to install a bunch of
dependencies on your system that you'll may never need again.

All you need to do, on a system connected to the internet, is run::

  make simpletest

The extensive test suite
------------------------


Any \*NIX system should be compitable enough to run the basic
test infrastructure. What you'll need in addition to a minimally
functional system.

- uuencode & uudecode: provided on Linux by the sharutils package.
- compress & uncompress: provided on Linux by the ncompress package.

.. note::

  Debian & Ubuntu rename ``uncompress`` to ``uncompress.real`` please
  make sure that the uncompress binary is available and compitable
  with uncompress as spicified by the POSIX-standard.

In addition you'll need these packages installed for testing purposes:

- shunit2_: Should be available at "/usr/share/shunit2/shunit2", this
  is the default for most distributions.
- ShellCheck_: The binary must be available on the system and included
  in $PATH.
- kcov_: Optionally, this is usefull to check if your tests cover all the
  code paths. You must run this manually.

All tests are ran using different shells. The following shells should be
available on the system:

- bash
- dash
- ksh
- mksh
- zsh
