systemd
=======

Manages systemd services.
Example::

  $ enshure systemd proftpd available

Type: service
-------------

States:

* available (default)
* started
* stopped
* enabled
* disabled
* restarted
* unavailable

Arguments
---------

* | **service**: String. Identifier.
  | The service to be managed.
  | Example: ``proftpd``
