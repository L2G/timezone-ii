#!/usr/bin/env bats

load helper

@test "/etc/timezone content correct" {
  if [ "debian" != "$ohai_platform_family" ]; then
    skip "test only applicable to debian family, not $ohai_platform_family family"
  fi

  grep -q -x Pacific/Tongatapu /etc/timezone
}
