# CMake Zephyr helpers

## Overview

This bunch of files allow to build Zephyr application without West
(Zephyr’s meta-tool). It is very useful while using CMake-based IDEs.
E.g. in VS Code you can just push CMake build/configure button in
[CMake extension](https://github.com/microsoft/vscode-cmake-tools) panel.

Zephyr supports to build by CMake, but with it lost some automatically
environment preparings. E.g. configurations set in West manifest. So these
scripts try to make up for the loss.


## How to use

> **Note** Application root is <u>not</u> the root of your C/C++ project. See
> [Zephyr freestanding
> application](https://docs.zephyrproject.org/latest/develop/application/index.html#zephyr-freestanding-application).

> **Note** If you want to setup CMake to build from the root of project
> see "Use from root of project" section below.

Add this repository as a submodule or Zephyr module somewhere in your project.
Copy **CMakeList.txt.app.template** directly into your project structure into
the root of your <u>application</u> (where "boards", "soc" and other
"out-of-tree" folders usually located) and rename it to **CMakeList.txt**. Path
to the helpers is assumed to be **/app/cmake/helpers**, but it can be any.

You should list your application source files in **app/CMakeList.txt** as
usual by passing it to the `target_sources` CMake function.

Customise your you IDE settings to set CMake source directory if it's needed.
For example for VS Code in **.vscode/settings.json** file add next line:

```js
"cmake.sourceDirectory": "${workspaceFolder}/app"
```

Now you can call CMake configure command from root folder with

```shell
cmake -Happ -Bbuild
```

there `app` is your application root directory relative to the root of the
project.

Another available and quite handy option to configure project is to use
**CMakePresets.json**. Copy it from the templates folder into the application
root. Correct some fields. Then you can run CMake configuration with

```bash
cmake . -Happ --preset qemu_riscv32
```

and build with

```bash
cmake --build ./app/build/qemu_riscv32
```

If your IDE supports CMakePresets.json (VS Code do) when you can select preset
and trigger configure/build process from IDE.

Finally you can use `west` to build and configure you application too if it's
needed.

### Use from root of project

If you don't want to move the root CMakeLists.txt to application root, you can
leave it in the project root. Just simply:

- copy **CMakeLists.txt.app.template** in your root and rename it to
  **CMakeList.txt**;
- set path to helpers correctly;
- create **CMakeLists.txt** in application root;
- move everything after line `project(app C CXX ASM)` into application root
  **CMakeLists.txt**;
- append project root **CMakeLists.txt** with
  `add_subdirectory(<path_to_application_root>)`.

It's done! You can configure and build your project. But remember that from now
there is no need in changing *CMake source directory* in your IDE settings and
during the command line build (you can get rid of `-H` arg).

## Zephyr location

The preferred way is to define a Zephyr location in **.west/config** file. You
can do it with `zephyr.base` option (see [Zephyr
docs](https://docs.zephyrproject.org/latest/guides/west/config.html)).
`zephyr.base-prefer` option should be also set to `configfile` to override
`ZEPYR_BASE` env variable. Otherwise `ZEPYR_BASE` env varialble will be used as
the Zephyr location by helpers.

You can also force the Zephyr location by setting `-DZEPHYR_BASE_LOC` CMake
argument.


## Application source dir

Zephyr finds "out of tree" DTS-files in
[APPLICATION_SOURCE_DIR](https://docs.zephyrproject.org/latest/develop/application/index.html#devicetree-definitions).
Helpers sets this variable to your application root, but you can rewrite it by
setting `APPLICATION_SOURCE_DIR` manually with flag `-DAPPLICATION_SOURCE_DIR`
or with the `set` CMake function. Do it before including helpers boilerplate.
`APPLICATION_SOURCE_DIR` must be an absolute path.

You also can set `DTS_ROOT` variable manualy to change DTS root without touching
application source dir. `DTS_ROOT` must be an absoulute path.


## Out of tree board

You can use `-DOUT_OF_TREE_BOARD=ON` to let helpers know if your application
root contains out of tree board description. You also can set it manually with
`-DBOARD_ROOT` according to the Zephyr docs.


Other arguments
===============

You can use other arguments, like `CONF_FILE` and `BOARD` as usual. See details
about these in Zephyr docs.


VS Code
=======

For VS Code IDE you can use "cmake-variants.yaml.template". Propose and
description of this could be found in [CMake Tools extension
docs](https://vector-of-bool.github.io/docs/vscode-cmake-tools/variants.html).
