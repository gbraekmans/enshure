Module types
============

Module types implement the logic needed to go from a system in a state
to the other state. They do not implement how it must be done, just
what needs to be done. If your writing a module, much of what needs
to be written is determined by it's module type.

TODO: Add module type 'info'

About states
------------

There are 2 kind of states for every module:

1. Requested state: the one supplied on the command line or by the type.
2. Actual state: the state the system is in.

The module type also defines the default requested state, if the user did not
explicitly give one.

The following types, with their states, are available in enSHure:

Type: Command
-------------

Everything which could be a command. An action that does something and
either fails or succeeds.

- Requested state: succeeds or fails.
- Actual state: succeeds or fails.

Type: Generic
-------------

Used for modules where a boolean check is requested. Something is either
present or absent. The actual state cat be present
(all conditions satisfied), abasent (none of the conditions satisfied) or
obsolete (some of the conditions satisfied).
A user or file module would be common modules.

- Requested state: present or absent.
- Actual state: present, absent or obsolete.

Type: Package
-------------

These kind of modules are only usefull when working with packages.
Present would be if the package is installed on the sytem, absent means
the packag is not installed on the system. Latest means there is no update
available for the package and it's installed.
Examples would be rpm, dnf, yum, apt, deb, pacman, portage, zypper,...

- Requested state: present, latest or absent.
- Actual state: present, latest or absent.

Type: Service
-------------

TODO: Rename always & never to better alternatives. Present/absent, Persistent/dead, Available, unavailable

These modules do everything service-related. Only usefull when working
with the init system. Examples would be systemd, sysv, upstart, runit,
openrc, ...

Posibble states:

- Requested state: always, started, stopped, enabled, disabled, never or restarted.
- Actual state: always, started, enabled or never

The **actual service states** are clearer when expained using this table:

+-------------+-------------+--------------+ 
|             | **Enabled** | **Disabled** | 
+-------------+-------------+--------------+ 
| **Started** | always      | started      | 
+-------------+-------------+--------------+ 
| **Stopped** | enabled     | never        |
+-------------+-------------+--------------+ 

When the requested state is disabled, the module does not care wether
the service is running or not.
When the requested state is stopped, the module does not care wether
the service is enabled or not.
When the requested state is restarted, the module does not care if the
service is running or enabled.
