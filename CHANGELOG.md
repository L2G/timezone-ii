# CHANGELOG for timezone-ii

This file is used to list changes made in each version of timezone-ii.

## Work in progress:

* Added experimental support for PLD (https://www.pld-linux.org; thanks to Elan
  Ruusamäe)
* Added support for RHEL/CentOS (thanks to "fraD00r4")
* Complete refresh of test-kitchen setup, including use of Berkshelf (thanks to
  Mike Conigliaro)

## 0.2.0:

* Initial release of timezone-ii (as forked from timezone)
* Added support for Fedora
* Configurable paths for localtime data and tzdata tree (just in case someone
  wants them...)
* For generic Linux timezone setting, a choice of copying or symlinking timezone
  data to localtime (copying is the default, to avoid surprises)

