#
# Cookbook Name:: timezone-ii
# Recipe:: fedora
#
# Copyright 2013, 2015 Lawrence Leonard Gilbert <larry@L2G.to>
#
# Apache 2.0 License.
#

# Fedora and EL 7 currently use the same timedatectl utility
include_recipe 'timezone-ii::rhel7'
