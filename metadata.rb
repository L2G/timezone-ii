name             "timezone-ii"
maintainer       "Lawrence Leonard Gilbert"
maintainer_email "larry@L2G.to"
license          "Apache 2.0"
description      "Configure the system timezone on Linux systems"
version          "0.1.7"

replaces         "timezone"

# These are platform versions where this cookbook has been tested at some point
# in time
supports "amazon", ">= 2012.09"
supports "centos", ">= 5.8"
supports "fedora", ">= 18.0"
supports "gentoo", ">= 2.1"
supports "ubuntu", ">= 10.04"

# These have not been tested but should also work
%w{ debian enterpriseenterprise linuxmint oracle raspbian redhat
    scientific }.each do |os|
  supports os
end
