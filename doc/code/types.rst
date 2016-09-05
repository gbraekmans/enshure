Module types
============

Module types implement the logic needed to go from a system in a state
to the other state. They do not implement how it must be done, just
what needs to be done. If your writing a module, much of what needs
to be written is determined by it's module type.

What's implemented in a type
############################

There are 3 functions which the core-script calls and thus should be available
in the type.

- ``is_state``: Checks wether the system is in a given state.
- ``attain_state``: Makes the system conform to the given state.
- ``verify_requirements``: Conditions which must be true before any actions
  can be performed by the module.

Typically the ``is_state`` and ``attain_state`` are duplicated per state.


Index of module types
#####################

The **bold** states are the default states of the type.

Type: Message
-------------

For every module whose purpose is to display information to the user.

Possible states: **info**, error, warning, debug

Type: Command
-------------

Everything which could be a command. Something that you would run in the shell.

Possible states: **executed**

Type: Generic
-------------

Used for modules where a boolean check is requested. Something is either
present or absent. A user or file module would be generic modules.

Possible states: **present**, absent


Type: Package
-------------

These kind of modules are only usefull when working with packages.
Examples would be rpm, dnf, yum, apt, deb, pacman, portage, zypper,...

Possible states: **installed**, latest, removed


Type: Service
-------------

These modules do everything service-related. Only usefull when working
with the init system. Examples would be systemd, sysv, upstart, runit,
openrc, ...

Posibble states: **available**, started, stopped, enabled, disabled, restarted, unavailable
