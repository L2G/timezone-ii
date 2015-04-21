Timezone II
===========

[![Join the chat at https://gitter.im/L2G/timezone-ii](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/L2G/timezone-ii?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The Timezone II cookbook contains recipes for installing the latest tzdata
(a.k.a. IANA or Olson) timezone database and setting the timezone on your
system.  It is a fork of the [timezone cookbook by James
Harton.](http://community.opscode.com/cookbooks/timezone)

Requirements
------------

This cookbook is known to work with:

* Amazon Linux
* CentOS and RHEL
* Debian
* Fedora
* Gentoo
* PLD Linux
* Ubuntu

It _should_ work with any OS that uses the IANA/Olson timezone database and
stores local timezone data in /etc/localtime (the only OS I know of that does
_not_ do this is MS Windows).  However, some OSs not mentioned above have their
own system utility for setting the timezone, and this may overwrite the changes
made by this cookbook.

Attributes
----------

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['tz']</tt></td>
    <td>String</td>
    <td>the timezone name as defined in tzdata</td>
    <td>"Etc/UTC" on Debian platforms; "UTC" for all other platforms</td>
  </tr>
  <tr>
    <td><tt>['timezone']['tzdata_dir']</tt></td>
    <td>String</td>
    <td>the path to the root of the tzdata files; the default value is for
    most known distributions of Linux</td>
    <td>/usr/share/zoneinfo</td>
  </tr>
  <tr>
    <td><tt>['timezone']['localtime_path']</tt></td>
    <td>String</td>
    <td>the path to the file used by the kernel to read the local timezone's
    settings; the default works for Linux and other *ix variants</td>
    <td>/etc/localtime</td>
  </tr>
  <tr>
    <td><tt>['timezone']['use_symlink']</tt></td>
    <td>Boolean</td>
    <td>whether to use a symlink into the tzdata tree rather than make a copy
    of the appropriate timezone data file (amazon and linux-generic recipes
    only)</td>
    <td>false</td>
  </tr>
</table>

Usage
-----

Set the "tz" attribute to your desired timezone and include the "timezone-ii"
recipe in your node's run list:

    {
      "name": "my_node",
      "tz": "Africa/Timbuktu",
      "run_list": [
        "recipe[timezone-ii]"
      ]
    }

### timezone-ii::default

The default recipe will first install or upgrade the IANA/Olson
timezone database package for your OS (`timezone-data` on Gentoo, `tzdata` on
all others). Then it will call one of the recipes below according to your
node's platform.

### timezone-ii::amazon

This changes the timezone on Amazon Linux by:

1. including the "timezone-ii::linux-generic" recipe, then
2. including the "timezone-ii::rhel" recipe.

Refer to the sections for those recipes for details.

### timezone-ii::debian

This changes the timezone on Debian-family platforms by:

1. writing the value of `tz` to `/etc/timezone`, then
2. calling `dpkg-reconfigure -f noninteractive tzdata`;
3. if `dpkg-reconfigure` amends the timezone value (e.g. by changing "UTC" to
   "Etc/UTC" or "EET" to "Europe/Helsinki"), it logs a warning.

Only the `tz` attribute is used; all others are ignored.

### timezone-ii::fedora

Because Fedora sets its timezone the same way RHEL 7 does, this simply
includes the "timezone-ii::rhel7" recipe.

### timezone-ii::linux-generic

This changes the time on all OSs without a more specific recipe. It assumes that
the kernel gets data on the local timezone from `/etc/localtime`. (This is true
for FreeBSD as well as Linux, so "linux-generic" is a bit of a misnomer.)

What this recipe does:

1. verifies that the value of `tz` corresponds with a timezone data file under
   the directory specified in `timezone.tzdata_dir` (default:
   `/usr/share/zoneinfo`), then
2. creates a copy of or symbolic link to that data file in the path specified in
   `timezone.localtime_path` (default: `/etc/localtime`).

The truthiness of `timezone.use_symlink` (default: `false`) determines whether a
symlink or a copy is made.

### timezone-ii::pld

This changes the timezone on PLD Linux. It writes the appropriate timezone
configuration file, making use of the `tz` and `timezone.tz_datadir` attributes.
Other attributes are ignored.

### timezone-ii::rhel

This changes the timezone on RedHat Enterprise Linux (RHEL) and RHEL-family
platforms such as CentOS.  It is intended only for versions prior to 7.0, but
should the recipe be called on a system with version 7.0 or newer, it will
automatically include the "timezone-ii::rhel7" recipe and do nothing else.

This recipe updates the `/etc/sysconfig/clock` file with the value of the `tz`
attribute, then calls `tzdata-update` (if available) to change the timezone.
All node attributes other than `tz` are ignored.

### timezone-ii::rhel7

This changes the timezone on EL 7 platforms by calling `timedatectl
set-timezone` with the value of `tz`.

Only the `tz` attribute is used; all others are ignored.

Contributing
------------
1. Fork the [repository on GitHub](https://github.com/L2G/timezone-ii)
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. If at all possible, write tests for your change and ensure they all pass
5. Submit a pull request using GitHub

Acknowledgements
----------------

Thanks to:

* James Harton, for launching the timezone cookbook
* Elan Ruusamäe, for PLD support
* Mike Conigliaro, for bringing testing up to date
* "fraD00r4", for RHEL/CentOS support


License and Authors
-------------------

Copyright © 2010 James Harton <james@sociable.co.nz>             
Copyright © 2013-2015 Lawrence Leonard Gilbert <larry@L2G.to>         
Copyright © 2013 Elan Ruusamäe <glen@delfi.ee>                   
Copyright © 2013 fraD00r4 <frad00r4@gmail.com>                   

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License.  You may obtain a copy of the
License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied.  See the License for the
specific language governing permissions and limitations under the License.
