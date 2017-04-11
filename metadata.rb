name 'timezone-ii'
maintainer 'Lawrence Leonard Gilbert'
maintainer_email 'larry@L2G.to'
license 'Apache 2.0'
description' Configure the system timezone on *ix systems'
version '0.2.0'

replaces 'timezone'

# These are platform versions where this cookbook has been tested at some point in time

%w(amazon centos debian fedora gentoo ubuntu pld redhat).each do |os|
  supports os
end

source_url 'https://github.com/L2G/timezone-ii' if defined?(:source_url)
issues_url 'https://github.com/L2G/timezone-ii/issues' if defined?(:issues_url)

chef_version '>= 12.1' if respond_to?(:chef_version)
