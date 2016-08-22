Design decisions
================

.. _POSIX: https://en.wikipedia.org/wiki/POSIX
.. _GNU: https://en.wikipedia.org/wiki/GNU

Using the shell
---------------

Writing any program which consists of more than 100 lines of code in a shell
script is, in general, a bad idea. You shoud seriously consider another language
if you want write anything large.
The only thing the shell, as a programming language, has going for it is it's
ubiquitous. Every \*NIX system has one available. This brings two advantages
over other languages:

1. Portable: run your code everywhere, just like Java, Python or Ruby.
2. Dependencyless: no need to install a runtime or a compiler.

POSIX-compliance, or why not bash?
----------------------------------

To opt out of POSIX_-compliance and allowing bashisms and the extensions the
GNU_ tools offer would certainly make things *a lot* easier. Using bash would, however,
make the code less portable. Using bash and GNU tools would be choosing for most
of the drawbacks of the shell and ignore it's omnipresence.
There are a huge amount of users running on outdated or non-GNU tools
(looking at you OS X and BSD-users).

If the code runs in dash_, consider it POSIX-compliant enough to run in every other
posix-compliant shell. Running with bash with -posix option will also catch most
bashisms.
Only the `utilities listed by the POSIX-standard`__ are assumed to be available
on every operating system.

.. _dash: http://git.kernel.org/cgit/utils/dash/dash.git
__ http://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html

.. note::

  The local keyword is supported by most (all?) shells these days. It is, however, not
  in the POSIX-standard. This means portable shell scripts have a significant
  amount of globals in them.

.. note::

  The lack of support for arrays is one of the biggest problems one faces when
  writing portable shell scripts. Most of these can be solved using functions and
  using the arguments as arrays, but I must admit it would have been nice to have.

Coding conventions
------------------

The `conventions at the bash wiki`__ are used throughout this project. There are
some extra conventions:

__ http://wiki.bash-hackers.org/scripting/style

Variable naming: globals uppercase, functions lowercase
*******************************************************

- Words are seperated by an underscore.
- Exported global variables are uppercase.
- Global variables not exported aslo uppercase but start with an underscore.
- Intended local variables should start with an underscore and be lower case.
- Public functions are named like local variables but lose the underscore
  prefix.
- Private functions are named like public functions but have 2 underscores
  prefixed.

Example::

  # A global variable
  THIS_IS_A_GLOBAL=""
  # A global variable within the script
  _THIS_IS_A_GLOBAL=""
  # Another global variable, but it should be local in a non-posix shell
  _this_is_a_local=""
  # A public function
  this_is_a_function() { : }
  # A private function
  __this_is_a_private_function() { : }

Public functions are functions which can be used from within the types and the
modules, private functions should only be called in the core.

.. note::

  There is no such thing as a private function in shell scripts. The double
  underscores are just a means to discourage it's use. But nothing prevents
  you from calling __this_is_a_private_function.

Linebreaks: 80 characters
*************************

Try **not** to go **over 80-characters**. This is not a rule, because splitting URL's is
something what makes the code less readable. The aim is to make the code the
readable, not conform a standard.

Indentation: 2-space tabs
*************************

All indentation should be done using **tabs** instead of spaces. This so heredocs
can be easily removed of their indentation. The default tab
**width** should be **2 spaces** (a quarter tab), in order to determine wether lines
should be broken at 80 characters.

Commenting
**********

Use comments where functionality is vague. ``sed`` and ``awk`` are great places
to add comments because it's not always clear what they intend to achieve. Large
pipes of commands should also be commented. **Use common sense**, but when in doubt
choose to include a comment.

Preventing errors
-----------------

Use shell options to limit the chance of a failure being unforseen. The
enSHure script sets by default the following `shell options`_::

  set -o errexit
  set -o nounset

.. note::

  ``set -o pipefail`` is not supported by all shells (dash for example), but
  it's used is in shells that support it.

.. _`shell options`: https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html#The-Set-Builtin

Coding style
------------

It's easy to flaunt your knowledge of the shell by using some of the more cryptic
ways of doing things. Better readable code is always preferred over concise code.

.. note::

  What about performance? In shell scripts we don't care about performance.
  Avoiding notoriously slow operations is considered a bad practice, **subshells
  are a good thing, and it's use is encouraged**.

Complex tests should be abstracted into a function with a clear name. Doing so
makes your code more readable. 

Testing
-------

Before testing takes place the entire code is statically checked for errors
using shellcheck_. If shellcheck returns any complaints, the test is considered
failed.

.. _shellcheck: http://www.shellcheck.net/

There are unit tests for *every* function. These are done with the help of
shunit2_, a POSIX-compliant testing framework. All the tests reside in the test
directory of the project.

.. _shunit2: https://github.com/kward/shunit2

The shells which are tested against:

- bash
- zsh
- ksh
- mksh
- dash

Limitations of the shell
------------------------

Not everything can be solved by the shell in a clear and efficient manner. For \
the more complex things, like parsing a yaml-file for example, it's
perfectly fine to use ``python``. When doing things not in the shell you should
turn to, in order of preference:

1. ``sed`` and ``awk``, but try to avoid the GNU-extensions to these utilities.
   We can assume these utilities to be available even on a minimal install.
2. ``python`` since it's becoming the new perl and thus is usually installed
   on most systems. Code should be in python3, and may be python2
   compatible.
3. Custom commands that solve your problem. Things like augeas_ or jq_ could be
   usefull, but it requires a command that is not part of a default install.

If at all possible try to make ``python`` and such not hard dependencies but optional which
improve the experience if installed, but are not required for the core functionality.

.. _augeas: http://augeas.net/
.. _jq: https://stedolan.github.io/jq/

