What can you expect of enSHure?
===============================


Runs everywhere
---------------

The basic functionality should be available on every POSIX_-compliant
operating system. Even better: enSHure runs on even the most minimal of sytems.
Even though it hasn't been tested enSHure could run even in the initramfs.

This doesn't mean that enSHure should be limited to only what the lowest common
denominator supports. You're encouraged to write code which opts-in usefull
features if they are available. It's perfectly possible for a module to work only on one operating system
or linux-distro as long as it's documented.

.. _POSIX: https://en.wikipedia.org/wiki/POSIX

Easy on the eyes
----------------

You should be able to spot at a glance what is happening to your system. enSHure
uses colors to make it easy to identify what's a message, what's a change and
what's an error.

Lots of programs require intimate knowledge of their options, switches
and arguments. Not so with enSHure, everything follows a straightforward
predictable rhythm. First the name of the option and then it's value.

Built for customization
------------------------

Most projects don't meet your requirements 100%, enSHure hopes to meet
80% of your requirements and tries to make it as easy as possible to
implement the remaining 20%.
Extending enSHure with new code should be simple, as in "Arch Linux"-simple, not necessarily
easy. Writing good shell scripts is hard.

Well tested
-----------

Before testing takes place the entire code is statically checked for errors
using ShellCheck_. If shellcheck returns any complaints, the test is considered
failed.

There are unit tests for every function. These are done with the help of
shunit2_, a POSIX-compliant testing framework. All the tests reside in the test
directory of the project. You could run the tests using kcov_ and verify
yourself that every function is tested.

.. _shunit2: https://github.com/kward/shunit2
.. _ShellCheck: http://www.shellcheck.net/
.. _kcov: https://github.com/SimonKagstrom/kcov

These shells are supported by enSHure:

- bash (OS X and Linux)
- zsh (OS X and Linux)
- ksh (BSD)
- mksh (Android, BSD)
- dash (Debian-based distro's)

Idempotent
----------

Commands are only executed if they need to be. This is pretty standard in every
configuration management software.
All the changes made by enSHure are logged by default. Every modification
to the system is logged with a time, date and user.


