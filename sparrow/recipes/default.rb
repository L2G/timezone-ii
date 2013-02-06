#
# Cookbook Name:: sparrow
# Recipe:: default
#
# Copyright 2013, Lawrence Leonard Gilbert <larry@L2G.to>
#
# May be redistributed and reused under terms of the Apache 2.0 license
#

include_recipe "sqlite"
gem_package "sparrow"
directory node.sparrow.spool_path
directory node.sparrow.pid_path
