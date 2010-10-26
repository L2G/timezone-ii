#
# Cookbook Name:: rvm
# Recipe:: default
#
# Copyright 2010, James Harton, Sociable Limited <james@sociable.co.nz>
#
# Loosely based on rvm_ree_default cookbook by Matthias Marshall
# (see: http://s.mashd.cc/prodigious)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Make sure that the package list is up to date on Ubuntu/Debian.
include_recipe "apt" if [ 'debian', 'ubuntu' ].member? node[:platform]

# Make sure we have all we need to compile ruby implementations:
package "curl"
package "git-core"
include_recipe "build-essential"
 
%w(libreadline5-dev zlib1g-dev libssl-dev libxml2-dev libxslt1-dev).each do |pkg|
  package pkg
end
 
bash "installing system-wide RVM stable" do
  user "root"
  code "bash < <( curl -L http://bit.ly/rvm-install-system-wide )"
  not_if "which rvm"
end

bash "upgrading to RVM head" do
  user "root"
  code "rvm update --head ; rvm reload"
  only_if { node[:rvm][:version] == :head }
  only_if { node[:rvm][:track_updates] }
end

bash "upgrading RVM stable" do
  user "root"
  code "rvm update ; rvm reload"
  only_if { node[:rvm][:track_updates] }
end

cookbook_file "/etc/profile.d/rvm.sh"

ruby_version = "#{node[:rvm][:ruby][:implementation]}-#{node[:rvm][:ruby][:version]}-#{node[:rvm][:ruby][:patch_level]}"

bash "installing #{ruby_version}" do
  user "root"
  code "rvm install #{ruby_version}"
  not_if "rvm list | grep #{ruby_version}"
end
 
bash "make #{ruby_version} the default ruby" do
  user "root"
  code "rvm --default #{ruby_version}"
  not_if "rvm list | grep '=> #{ruby_version}'"
end
 
gem_package "chef" # re-install the chef gem into rvm to enable subsequent chef-client runs
