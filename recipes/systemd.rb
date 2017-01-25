#
# Cookbook Name:: timezone-ii
# Recipe:: systemd
#
# Copyright 2015 Lawrence Leonard Gilbert <larry@L2G.to>
#
# Apache 2.0 License.
#

# This sets the timezone on distributions that use systemd (e.g. RedHat, CentOS, Debian)
execute "timedatectl --no-ask-password set-timezone #{node[:tz]}"
