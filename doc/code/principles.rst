Project goals
=============

This page explains why the enSHure is designed the way it is. Nothing on
this page is critical if you just want to contribute to the project. It
provides some background information for anyone who's interested.

Hackable: Make it your own
--------------------------

Most projects don't meet your requirements 100%, enSHure hopes to meet
80% of your requirements and tries to make it as easy as possible to
implement the remaining 20%.
Extending enSHure with new code should be simple, as in "Arch Linux"-simple, not necessarily
easy. Writing good shell scripts is hard.

.. note::

  It's hard to find a good balance between "automatic" or "boilerplate". If you opt
  for boilerplate code new contributors find it relatively easy to follow the
  execution path and what is happening. If you lean towards automatic (or convention
  over configuration) you should have your stuff well-documented. Even then it's
  sometimes hard to follow the execution path. But it will be easier
  for modules to stay up to date, because they don't need to conform to
  a template. enSHure is closer to automatic than boilerplate.

Portable: POSIX-compliant shell script
--------------------------------------

The basic functionality should be available on every POSIX_-compliant
operating system. This pretty much limits your choice to portable C or
shell scripting. enSHure is a shell script because unix **admins have been
using the shell for years to configure their systems**.

This doesn't mean that enSHure should be limited to only what the lowest common
denominator supports. You're encouraged to write code which opts-in usefull
features if they are available.

It's perfectly fine for a module to work only on one operating system
or linux-distro as long as it's documented.

.. _POSIX: https://en.wikipedia.org/wiki/POSIX

.. note::

  If you're extending enSHure, POSIX-compliant shell is considered
  the default. There should be a good reason why in your case another
  language was used to solve the problem.

Why shell and not Python, Ruby or Go?
#####################################

Writing any program that consists of more than 100 lines of code in a shell
script is, in general, a bad idea. You shoud seriously consider another language
if you want write anything this large.
The only thing the shell, as a programming language, has going for it is it's
ubiquity. Every \*NIX system has Bourne compatible shell available. This means it has two major advantages:

1. Portable: run your code on any CPU architecture, just like Java, Python or Ruby.
2. Dependencyless: no need to install a runtime or a compiler. Just plug & play.

Why don't you use bash?
#######################

To opt out of POSIX_-compliance, allowing bashisms and the extensions the
GNU_ tools offer would certainly make things *a lot* easier. But using bash would
make the code less portable. Using bash and GNU tools would be choosing for most
of the drawbacks of the shell (Python is a lot nicer for programming) and ignore the biggest advantage: the omnipresence of the bourne shell.
There are a huge amount of users running on outdated or non-GNU tools
(looking at you OS X and BSD-users).

.. _GNU: https://en.wikipedia.org/wiki/GNU

.. note::

  The lack of support for arrays is one of the biggest problems one faces when
  writing portable shell scripts. Most of these can be solved using functions and
  using the arguments as arrays, but it would have been nice to have.

If the code runs in dash_, consider it POSIX-compliant enough to run in every other
posix-compliant shell. Running with bash with -posix option is not enough and will not catch
all bashisms.
Only `utilities listed by the POSIX-standard`__ and the shell are assumed to be available on every operating system enSHure is invoked.

.. _dash: http://git.kernel.org/cgit/utils/dash/dash.git
__ http://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html

Reliable: Not your average shell script
---------------------------------------

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

The shells which are tested against:

- bash (OS X and Linux)
- zsh (OS X and Linux)
- ksh (BSD)
- mksh (Android, BSD)
- dash (Debian-based distro's)

Traceable & idempotent
----------------------

All the changes made by enSHure are logged by default. Every modification
to the system is logged with a time, date and user.

Commands are only executed if they need to be. This is pretty standard in every tool you
can use to manage your configuration.
