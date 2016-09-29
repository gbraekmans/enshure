file
====

Creates or removes a file.
Example::

  $ enshure file /root/.bashrc present

Type: generic
-------------

States:

* present (default)
* absent

Arguments
---------

* | **file_path**: String. Identifier.
  | The path to the file.
  | Example: ``/root/.bashrc``
* | **user**: String. Optional.
  | The owner of the file.
  | Example: ``root``
* | **group**: String. Optional.
  | The group-ownership of the file.
  | Example: ``root``
* | **mode**: Integer. Optional.
  | The permissions of the file.
  | Example: ``755``
* | **content**: String. Optional.
  | The content of the file as printed by printf.
  | Example: ``Hello World\n``
* | **source_file**: String. Optional.
  | Use the content of a local file.
  | Example: ``/root/hello_world.txt``
* | **source_url**: String. Optional.
  | Use the content of a file available by URL.
  | Example: ``http://example.net/hello_world.html``
