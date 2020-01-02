# Monilet 

[![Full Code](https://raw.github.com/kmal-kenneth/monilet/master/data/images/badge.png)](https://gitlab.com/kmal-kenneth/monilet)

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.kmal-kenneth.monilet)﻿

![Travis (.com)](https://img.shields.io/travis/com/kmal-kenneth/monilet)

![GitHub release (latest by date)](https://img.shields.io/github/v/release/kmal-kenneth/monilet)

![GitHub](https://img.shields.io/github/license/kmal-kenneth/monilet)

![GitHub language count](https://img.shields.io/github/languages/count/kmal-kenneth/monilet)

![GitHub top language](https://img.shields.io/github/languages/top/kmal-kenneth/monilet)

![GitHub issues](https://img.shields.io/github/issues/kmal-kenneth/monilet)

![GitHub All Releases](https://img.shields.io/github/downloads/kmal-kenneth/monilet/total)

![GitHub repo size](https://img.shields.io/github/repo-size/kmal-kenneth/monilet)

![GitHub last commit](https://img.shields.io/github/last-commit/kmal-kenneth/monilet)

![GitHub Release Date](https://img.shields.io/github/release-date/kmal-kenneth/monilet)

![Maintenance](https://img.shields.io/maintenance/yes/2020)

![Monilet Screenshot](https://raw.github.com/kmal-kenneth/monilet/master/data/images/screenshot.png)

See percentage of use your CPU and number of cores. Also percentage used memory, amount of memory used and total memory.

## Installation

### Dependencies

You'll need the following dependencies to build:

* libgtk-3-dev
* libcairo2-dev
* libglib2.0-dev
* libgtop2-dev
* libgranite-dev
* meson
* valac

To install the dependencies. Adjust the command for your repository versions.

```bash
sudo apt install libgtk-3-dev libcairo2-dev libglib2.0-dev libgtop2-dev libgranite-dev valac
```

### Building

```bash
meson build --prefix=/usr
cd build
ninja
```

### Installing & executing

To install, use `ninja install`, then execute with `com.github.kmal-kenneth.monilet`.

```bash
sudo ninja install
com.github.kmal-kenneth.monilet
```