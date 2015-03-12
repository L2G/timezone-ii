#
# Cookbook Name:: timezone-ii
# Recipe:: amazon
#
# Copyright 2014, Lawrence Leonard Gilbert <larry@L2G.to>
#
# Apache 2.0 License.
#

# Amazon recommends editing /etc/sysconfig/clock as in the rhel recipe, but then
# creating a link for /etc/localtime.  It doesn't have a tzdata-update command
# like the other flavors of RHEL.
#
# Source: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html
# (as of 2014-12-18)

include_recipe 'timezone-ii::linux-generic'
include_recipe 'timezone-ii::rhel'
