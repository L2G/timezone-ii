maintainer       "Lawrence Leonard Gilbert"
maintainer_email "larry@L2G.to"
license          "Apache 2.0"
description      "Configure the system timezone on Linux systems"
version          "0.1.4"

# Should support any OS in the "debian" and "rhel" families, as defined by Ohai
%w{ amazon centos debian gentoo enterpriseenterprise linuxmint oracle raspbian
    redhat scientific ubuntu }.each do |os|
  supports os
end
