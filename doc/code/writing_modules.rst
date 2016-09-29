Writing a module, step by step
==============================

The design of enSHure makes it as easy as possible to write a module.
If you know the basics of shell-scripting and you've read this page then you
should be able to write any module. We'll build a command-module which allows
the execution of arbitrary commands.

Step 1: Create a skeleton module
--------------------------------

All the enSHure modules are located in the ``src/modules`` directory. To create
our module, named ``my_commmand``, we need to create the file named as such::

  touch src/modules/my_command.sh

Now fire up your preferred editor and set the indentation-style to tabs.

.. note::

  If your module consists of multiple source files, you can create a directory
  with the name ``my_command`` and enSHure will load ``my_command/main.sh``.

By looking at all the possible types, it's quite clear that the command type
is in this case the most usefull for our purposes. So let's use that, we'll
start our brand new module with the following line::

  module_type 'command'

Step 2: Find out what's needed by the type
------------------------------------------

Because we know our module will be of the type "command", we open up
``src/types/command.sh`` and take a quick look at what's defined there.
The lines which matter to us are highlighted.

.. literalinclude:: ../../src/types/command.sh
   :emphasize-lines: 3,20,26

The first highlighted line tells us that there's only **1 state** for this
for this type: '**executed**'.
The second line is the **function** we need to **override** in our module to **check** wether
the system is in the correct state.
And the third line is the function we need to override to **set** the system in the
requested state.

Now we can add these functions to the module::

  module_type 'command'
  
  is_state_executed() {
  	true
  }
	
  attain_state_executed() {
  	true
  }

Step 3: What to execute?
------------------------

Now we need some way to get the argument functions from the command line to the
module. The ``argument`` function does just that. This function expects at least
five but accepts six arguments:

1. name: How it should be known to the module **and** the user.
2. value type: If this argument is a string, integer, float, boolean or enum(...)
3. argument type: wether it is required, optional or if it's the identifier.
4. help: a help message for the user.
5. example: an example to further help the user.
6. default value: An optional default value if the user doesn't supply the argument.

We want that ``enshure my_command 'echo test'`` executes ``echo test`` and thus
we need to add an argument of the identifier type.

::

  module_type 'command'
  
  argument statement string identifier "What needs to be executed." "echo test"
  
  is_state_executed() {
  	true
  }
	
  attain_state_executed() {
  	true
  }

Step 4: Implement the main logic
--------------------------------

At the end of this step your module will be working correctly in enSHure. Pretty
simple up until now right? And it won't be much harder now.

Because we want the command to run each time enSHure is called, the logic for
the ``is_state_executed`` function is really simple::

  is_state_executed() {
  	return 1
  }

For the ``attain_state_executed`` function we simply want to execute the
command given by the user.

::

  attain_state_executed() {
  	run "$statement"
  }

The statement given by the user, as the identifier, is available to us in the
``$statement`` variable. Every argument we'll define is available to through
the variable by the same name.

Notice we used the ``run`` function. This function should be used every time
you make a (possible) modification to the system. ``run`` will set up the
logging required for the action.

.. warning::

  The ``run`` function, by default, does not print anything to the stdout. You should not
  pipe the output into some other function. If you want this, you should use
  ``run "<statement>" "" no_log``.

Step 5: Add some polish
-----------------------

The module works, but there are still some improvements left.

1. Add a description for the module.
2. Support for multiple languages.

We'll tackle these together, and the resulting module is still pretty
self-explanatory::

  module_type 'command'
  module_description "$(translate "Executes a given command")"
  
  argument statement string identifier "$(translate "What needs to be executed.")" "echo test"
  
  is_state_executed() {
  	return 1
  }
	
  attain_state_executed() {
  	run "$statement"
  }

Step 6: Start hacking!
----------------------

Open up an existing module and look around at how it works and what is used
where. After reading a couple of more complex modules you should have enough
information to start creating your own modules!
