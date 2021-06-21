CMake Zephyr helpers
####################

Overview
========

This bunch of files allow to build Zephyr application without West
(Zephyr’s meta-tool). It is very useful while using CMake-based IDEs.
E.g. in VS Code you can just push CMake build/configure button in
`CMake extension
<https://github.com/microsoft/vscode-cmake-tools>`_ panel.

Zephyr supports to build by CMake, but with it lost some automatically
environment preparings. E.g. configurations set in West manifest.
So these scripts try to make up for the loss.

How to use
==========

Add this repository as a submodule or Zephyr module, e.g. into your
"app" folder. Name of a folder with the submodule is assumed to be
"cmake/helpers".

Files named like "CMakeList.txt.<name>.template" should be copied directly
into your project structure and renamed to "CMakeList.txt".
**app** template — into the root of your application (where "boards",
"soc" and other "out-of-tree" folders usually located).

You should add your application source files in **app** CMakeList.txt as
usual.

Set CMake source directory by passing to CMake `-H` flag e.g.
`-Happ` or use you IDE settings. For example for VS Code in
`.vscode/settings.json` add next line:
`"cmake.sourceDirectory": "${workspaceFolder}/app"`

Now you can call CMake configure from root folder with

.. code-block:: shell

   cmake -Happ -Bbuild

Or trigger build by CMake-supported IDE.


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

   cmake -Happ -Bbuild -DOUT_OF_TREE_SOC -DOUT_OF_TREE_BOARD .

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
