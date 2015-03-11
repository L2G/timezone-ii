#!/usr/bin/env bats

@test "/etc/localtime content correct" {
  diff -q /etc/localtime /usr/share/zoneinfo/Pacific/Tongatapu
}

@test "/etc/localtime not a symlink (default behavior)" {
  [ '!' -L /etc/localtime ]
}
