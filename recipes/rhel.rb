#
# Cookbook Name:: timezone-ii
# Recipe:: rhel
#
# Copyright 2013, fraD00r4 <frad00r4@gmail.com>
# Copyright 2015, Lawrence Leonard Gilbert <larry@L2G.to>
#
# Apache 2.0 License.
#

# If it is being run on EL 7 or newer, the recipe will be skipped and
# the "rhel7" recipe will be included instead.
el_version = node[:platform_version].split('.')[0].to_i

if node.platform != 'amazon' && el_version >= 7
  include_recipe 'timezone-ii::rhel7'
else
  include_recipe 'timezone-ii::rhel_pre7'
end
