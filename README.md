<p align="center">
    <img align="left" width="64" height="64" src="data/icons/64/com.github.kmal-kenneth.monilet.svg">
    <h1 class="rich-diff-level-zero">Monilet</h1>
</p>

<p align="right">
  <a href="https://appcenter.elementary.io/com.github.kmal-kenneth.monilet"><img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter"></a>
  <a href="https://gitlab.com/kmal-kenneth/monilet"><img src="https://raw.github.com/kmal-kenneth/monilet/master/data/images/badge.png" alt="Full Code"></a>
</p>

<p align="center">
  <img alt="Travis (.com)" src="https://img.shields.io/travis/com/kmal-kenneth/monilet">
  <img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/kmal-kenneth/monilet">
  <img alt="GitHub" src="https://img.shields.io/github/license/kmal-kenneth/monilet">
  <img alt="GitHub language count" src="https://img.shields.io/github/languages/count/kmal-kenneth/monilet">
  <img alt="GitHub top language" src="https://img.shields.io/github/languages/top/kmal-kenneth/monilet">
  <img alt="GitHub issues" src="https://img.shields.io/github/issues/kmal-kenneth/monilet">
  <img alt="GitHub All Releases" src="https://img.shields.io/github/downloads/kmal-kenneth/monilet/total">
  <img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/kmal-kenneth/monilet">
  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/kmal-kenneth/monilet">
  <img alt="GitHub Release Date" src="https://img.shields.io/github/release-date/kmal-kenneth/monilet">
  <img alt="Maintenance" src="https://img.shields.io/maintenance/yes/2020">
</p>

<p align="center">
    <img alt="Monilet Screenshot" src="https://raw.github.com/kmal-kenneth/monilet/master/data/images/screenshot.png">
</p>

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
