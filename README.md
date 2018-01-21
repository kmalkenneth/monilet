# Monilet
[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.kmal-kenneth.monilet) 

[![Full Code](https://raw.github.com/kmal-kenneth/monilet/master/data/images/badge.png)](https://gitlab.com/kmal-kenneth/monilet)

See percentage of use your CPU and number of cores. Also percentage used memory, amount of memory used and total memory.

![Monilet Screenshot](https://raw.github.com/kmal-kenneth/monilet/master/data/images/screenshot.png)

## Building and Installation

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

