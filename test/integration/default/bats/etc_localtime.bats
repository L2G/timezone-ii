#!/usr/bin/env bats

load helper

symlink_ok_on_this_platform () {
  [ "centos" == "$ohai_platform" ] || \
  [ "fedora" == "$ohai_platform" ]
}

@test "/etc/localtime content correct" {
  diff -q /etc/localtime /usr/share/zoneinfo/Pacific/Tongatapu
}

@test "/etc/localtime not a symlink (default linux-generic behavior)" {
  if symlink_ok_on_this_platform; then
    skip "Not applicable to $ohai_platform"
  fi

  [ '!' -L /etc/localtime ]
}
