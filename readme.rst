enSHure
=======

.. image:: https://travis-ci.org/gbraekmans/enshure.svg?branch=master
   :target: https://travis-ci.org/gbraekmans/enshure

.. image:: https://coveralls.io/repos/github/gbraekmans/enshure/badge.svg?branch=coverage
   :target: https://coveralls.io/github/gbraekmans/enshure?branch=coverage


Easy-extendable and dependencyless configuration management for Linux, BSD and OS X.
It's written in portable shell script, and works in bash, dash, ksh, mksh and zsh.

- Easy installable, just download the archive or clone this repository.
- No dependencies, even the most minimal systems can run it.
- Portable, POSIX-compliance makes it work on any operating system.
- Well documented, from user to developer
- Logs everything, so you can easily trace where the modification to the system
  was made.

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

That's something pretty unreadable and you'd probably need to read some man
pages and run some tests before you'd write something like this.
If you'd use enSHure it would look something like this:

.. code:: bash

  enshure inifile "/etc/gdm3/daemon.conf" present \
                  section "daemon" \
                  option "AutomaticLoginEnable" \
                  value "true"

  enshure inifile "/etc/gdm3/daemon.conf" present \
                  section "daemon" \
                  option "AutomaticLogin" \
                  value "root"

Although it's more verbose, it also increases the readability of your script.
It's much easier and faster to write this code.
If you ever need to change the file again it's a lot easier to write some
enSHure lines than think up a new sed/awk expression.

Installation
------------

This project can be installed by just cloning the git repositiory, and including
the location in the PATH variable.

Contributing
------------

Every contribution is much appreciated from spelling errors, and making
documentation more readable to huge pull requests.

Some of the things I'd like help with:

- Packaging: deb, rpm, pacman, ...
- Testing: enSHure is mainly tested on debian-based machines. Testing and
  bugfixing on another OS (RedHat, BSD, OS X, ...) would be much appreciated.

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
