# CHANGELOG for timezone-ii

This file is used to list changes made in each version of timezone-ii.

## Work in progress:

* Added experimental support for PLD (https://www.pld-linux.org; thanks to Elan
  Ruusamäe)
* Added support for RHEL family (thanks to "fraD00r4")
* Complete refresh of test-kitchen setup, including use of Berkshelf (thanks to
  Mike Conigliaro)
* Added support for Amazon Linux as a special RHEL case
* Debian recipe now logs a warning if dpkg-reconfigure is rewriting the value
  in /etc/timezone (for example, changing "UTC" to "Etc/UTC")
* Because of the aforementioned behavior of dpkg-reconfigure, the default
  timezone for Debian-based platforms is now "Etc/UTC"

## 0.2.0:

* Initial release of timezone-ii (as forked from timezone)
* Added support for Fedora
* Configurable paths for localtime data and tzdata tree (just in case someone
  wants them...)
* For generic Linux timezone setting, a choice of copying or symlinking timezone
  data to localtime (copying is the default, to avoid surprises)

