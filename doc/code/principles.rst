Project goals
=============

enSHure is designed along these five principles:

Easily extendable
-----------------

Creating new code should be simple, as in "Arch Linux"-simple, not necessarily
easy. Writing good shell scripts is hard.

This also means that it's not always easy to understand what's going on under
the hood. It's not as bad as in `Ruby on Rails`__ but it may seem there's magic
in the codebase.

.. note::

  It's hard to find a good balance between "magic" or "boilerplate". If you opt
  for boilerplate code new contributors find it relatively easy to follow the
  execution path and what is happening. If you lean towards magic (or convention
  over configuration) you should have your stuff well-documented. Even then it's
  sometimes hard to follow the execution path. enSHure's design leans towards
  the latter and minimizes the amount of boilerplate code.

__ http://rubyonrails.org/

Portable
--------

The basic functionality should be available on every operating system which has
a Bourne-like shell available.

This doesn't mean that enSHure should be limited to only what the lowest common
denominator supports. It's encouraged to write code which opts-in advanced
features if they are available.

Reliable
--------

Extensive testing of all code, every function has tests. Then there are further
tests to verify if the functions are composed as they should.

All the work done by enSHure should be logged. Every modification to the system
should be traceable to a time, date and user.

Idempotent
----------

The functions only run if needed to. This is pretty standard in every tool you
can use to manage your configuration.

Standalone
----------

It's not written as a set of shell functions to include in your current setup
scripts, but as executable script so that your own shell scripts stay clean
of any pollution from running enSHure.
