Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``tool_vim``
~~~~~~~~~~~~
*Meta-state*.

Performs all operations described in this formula according to the specified configuration.


``tool_vim.package``
~~~~~~~~~~~~~~~~~~~~
Installs the Vim package only.


``tool_vim.xdg``
~~~~~~~~~~~~~~~~
Ensures Vim adheres to the XDG spec
as best as possible for all managed users.
Has a dependency on `tool_vim.package`_.


``tool_vim.config``
~~~~~~~~~~~~~~~~~~~
Manages the Vim package configuration by

* recursively syncing from a dotfiles repo

Has a dependency on `tool_vim.package`_.


``tool_vim.plug``
~~~~~~~~~~~~~~~~~



``tool_vim.clean``
~~~~~~~~~~~~~~~~~~
*Meta-state*.

Undoes everything performed in the ``tool_vim`` meta-state
in reverse order.


``tool_vim.package.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the Vim package.
Has a dependency on `tool_vim.config.clean`_.


``tool_vim.xdg.clean``
~~~~~~~~~~~~~~~~~~~~~~
Removes Vim XDG compatibility crutches for all managed users.


``tool_vim.config.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the configuration of the Vim package.


``tool_vim.plug.clean``
~~~~~~~~~~~~~~~~~~~~~~~



