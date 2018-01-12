# Monilet
Coming soon in [![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.danrabbit.nimbu) Full code in [![Full Code](https://raw.github.com/kmal-kenneth/monilet/master/data/badge.svg)](https://gitlab.com/kmal-kenneth/monilet)

See percentage of use your CPU and Alse percentage used memory, amount of memory used and total memory.

![Monilet Screenshot](https://raw.github.com/kmal-kenneth/monilet/master/data/screenshot.png)

## Building, Testing, and Installation

You'll need the following dependencies to build:

* libgtk-3-dev
* libcairo2-dev
* libglib2.0-dev
* libgtop2-dev
* libgranite-dev
* cmake
* valac

You'll need the following dependencies to run:

* gtop2

Run `cmake -DCMAKE_INSTALL_PREFIX=/usr ../` to configure the build environment and run `make` to build.
	
    cmake -DCMAKE_INSTALL_PREFIX=/usr ../
    make

To install, use `make install`, then execute with `com.github.kmal-kenneth.monilet`.

    sudo make install
    com.github.kmal-kenneth.monilet

