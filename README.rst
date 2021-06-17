CMake Zephyr helpers
####################

Overview
========

This bunch of files allow to build Zephyr application from the root folder.
It is very useful while using CMake-based IDEs. E.g. in VS Code you can just
push CMake build/configure button in `CMake extension
<https://github.com/microsoft/vscode-cmake-tools>`_ panel.


How to use
==========

Add this repo as a submodule into your "app" folder. Name of a folder with the
submodule is assumed to be "cmake".

Files named like "CMakeList.txt.<name>.template" should be copied directly
into your project structure and renamed to "CMakeList.txt". **root** template
should be copied into the root of your project, **app** — into the root of
your application (where "boards", "soc" and other "out-of-tree" folders
usually located).

You should add your application source files in **app** CMakeList.txt as
usual.

Now you can call CMake configure from root folder with

.. code-block:: shell

   cmake -B build .


Zephyr location
===============

The preferred way is to define a Zephyr location in ".west/config" file.
You can do it with ``zephyr.base`` option (see `Zephyr docs
<https://docs.zephyrproject.org/latest/guides/west/config.html>`_).
``zephyr.base-prefer`` option should be also set to "configfile"
to override ``ZEPYR_BASE`` env variable. Otherwise ``ZEPYR_BASE`` will
be used as the Zephyr location.

You can also force the Zephyr location by setting ``-DZEPHYR_BASE_LOC``
CMake argument.


Out-of-tree folders
===================

If you want to enable out-of-tree folders for soc, board or dts you can
use ``-DOUT_OF_TREE_<what>``. For example:

.. code-block:: shell

   cmake -B build -DOUT_OF_TREE_SOC -DOUT_OF_TREE_BOARD .

Folders should be located in the application folder root.


Other arguments
===============

You can use other arguments, like ``CONF_FILE``, ``BOARD`` or
``ZEPHYR_MODULES`` as usual. See details about these in Zephyr docs.

VS Code
=======

For VS Code IDE you can use "cmake-variants.yaml.template". Propose and
description of this could be found in `CMake Tools extension docs
<https://vector-of-bool.github.io/docs/vscode-cmake-tools/variants.html>`_.
