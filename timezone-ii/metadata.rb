maintainer       "Lawrence Leonard Gilbert"
maintainer_email "larry@L2G.to"
license          "Apache 2.0"
description      "Configure the system timezone on Linux systems"
version          "0.1.5"

replaces         "timezone", "= 0.0.1"

# These are platform versions where this cookbook has been tested at some point
# in time
supports "amazon", ">= 2012.09"
supports "fedora", ">= 18.0"
supports "gentoo", ">= 2.1"

# These have not been tested but should also work
%w{ centos debian enterpriseenterprise linuxmint oracle raspbian redhat
    scientific ubuntu }.each do |os|
  supports os
end
