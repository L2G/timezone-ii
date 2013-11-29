name             "timezone-ii"
maintainer       "Lawrence Leonard Gilbert"
maintainer_email "larry@L2G.to"
license          "Apache 2.0"
description      "Configure the system timezone on Linux systems"
version          "0.2.1"

replaces         "timezone"

# These are platform versions where this cookbook has been tested at some point
# in time

%w{ debian ubuntu rhel amazon centos scientific fedora gentoo pld }.each do |os|
  supports os
end