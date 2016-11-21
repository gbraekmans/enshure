enSHure
=======

Easy-extendable and dependencyless configuration management for Linux, BSD and OS X.

You should be using enSHure because it's:

- Easy installable, just download the archive or clone this repository. Even the
  most minimal systems are able to run enSHure without extra dependencies.
- Portable, POSIX-compliance makes it work on any operating system.
- Documented, First the documentation is written, then the tests and only then
  the code.
- Logging all it's operations and every modification can be traced through the
  log file.

Usage
-----

enSHure is designed to be an add-on tool to your existing bash scripts. Let's
say you want to enable autologin in GNOME3, and you add this to your homemade
setup script:

.. code:: bash

  if ! grep '^AutomaticLoginEnable' /etc/gdm3/daemon.conf > /dev/null; then
	  sed -i '/\[daemon\]/a AutomaticLoginEnable=true\nAutomaticLogin=root' \
	      /etc/gdm3/daemon.conf
  fi

if you use enSHure it would look something like this:

.. code:: bash

  enshure inifile "/etc/gdm3/daemon.conf" "present" \
                  section "daemon" \
                  option "AutomaticLoginEnable" \
                  value "true"

  enshure inifile "/etc/gdm3/daemon.conf" "present" \
                  section "daemon" \
                  option "AutomaticLogin" \
                  value "root"

Although it's more verbose, it also increases the readability of your script.
If you ever need to change the file again it's a lot easier to write some
enSHure lines than think up a new sed/awk expression.

Installation
------------

This project can be installed by just cloning the git repositiory, and including
the location in the PATH variable.

On a **GNU/Linux** you should have the following the packages installed to be able
to run a full test:

- gettext
- ncompress
- sharutils
- shellcheck
- bash
- dash
- ksh
- mksh
- zsh

To verify code coverage you'll need a recent version of kcov_.

.. _kcov: https://github.com/SimonKagstrom/kcov


Contributing
------------

Every contribution is much appreciated from spelling errors, and making
documentation more readable to huge pull requests.

More information about why design choices were made can be found in DESIGN.RST


License
-------

Licencesed under the GPLv3 or newer.

Thanks
------

I would like to thank Joe Topjian (@jtopjian) for creating waffles_. It's by
contributing to his project that I was able to finally understand how I would
design enSHure.

Another example has been the Gentoo_ project. Their ebuilds served as models for
the modules in enSHure.

.. _waffles: https://github.com/wffls/waffles
.. _gentoo: https://www.gentoo.org/
