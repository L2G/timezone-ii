#!/usr/bin/env bats

@test "Date output in correct time zone" {
  date | grep -q " TOT "
}
