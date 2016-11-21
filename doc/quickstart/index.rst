enSHure in 5 minutes
====================

.. _wordpress: https://wordpress.com/

We'll configure a Debian Jessie machine to act as a simple LAMP-server for
running wordpress_.

# http://www.tecmint.com/install-wordpress-using-apache-in-debian-ubuntu-linux-mint/

Step 1. Getting enSHure
-----------------------


Step 2. Preparing the machine
-----------------------------

We'll need to install several packages if we want to run wordpress on our
server. As we've already seen, enSHure is nothing more than a fancy shellscript
so we can easily add them::

..role=lamp
..enshure --task begin $role
..enshure --task begin $role::packages

  packages="apache2 apache2-utils php5 php5-mysql mariadb-client mariadb-server"
  for pkg in $packages; do
  	enshure apt_package $pkg installed
  done

  enshure --task end

Step 3. Getting the wordpress source
------------------------------------

::

  enshure --task begin $role::wordpress-source
  enshure file /root/wp.tar.gz present source_url http://wordpress.org/latest.tar.gz
	enshure directory /var/www/html present
  enshure archive /root/wp.tar.gz unpacked directory /var/www/html
  enshure --task end

Step 4. Starting the services
-----------------------------
