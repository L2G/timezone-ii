#
# Cookbook Name:: timezone-ii
# Recipe:: rhel7
#
# Copyright 2015 Lawrence Leonard Gilbert <larry@L2G.to>
#
# Apache 2.0 License.
#

# This sets the timezone on EL 7 distributions (e.g. RedHat and CentOS)
execute "timedatectl --no-ask-password set-timezone #{node['tz']}"
