Translating enSHure
===================

One of the easiest ways to contribute to enSHure is by translating the
application into another language.

Adding a new language
---------------------

First generate the pot file by running::

  $ make i18n
 
Now create a new .po-file for your language (en, nl, fr, it,...) under
the src/po directory::

  $ cd src/po
  $ msginit -i enSHure.pot -l nl.UTF-8

You can now edit the ``nl.po`` file.
  
.. note::

  Please add the ``UTF-8``-suffix so your system will chose utf-8 as the
  encoding, instead of some older obsolete encoding.

Updating a translation-file
---------------------------
