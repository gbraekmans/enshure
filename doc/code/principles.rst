Project goals
=============

enSHure is designed along these five principles:

Easily extendable
-----------------

Creating new code should be simple, as in "Arch Linux"-simple, not necessarily
easy. Writing good shell scripts is hard.

This also means that it's not always easy to understand what's going on under
the hood. It's not as bad as in `Ruby on Rails`__ but there may be some magic
in the codebase. All this "magic" is well-documented in the following sections.

__ http://rubyonrails.org/

Portable
--------

The basic functionality should be available on every operating system which has
a Bourne-like shell available.

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
