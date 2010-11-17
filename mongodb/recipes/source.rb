#
# Cookbook Name:: mongodb
# Recipe:: source
#
# Author:: Gerhard Lazu (<gerhard.lazu@papercavalier.com>)
#
# Copyright 2010, Paper Cavalier, LLC
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
#

platform = node[:kernel][:machine]

include_recipe "build-essential"

user "mongodb" do
  comment "MongoDB Administrator"
  system true
  shell "/bin/false"
end

remote_file "/tmp/mongodb-#{node[:mongodb][:version]}.tar.gz" do
  source node[:mongodb][:source]
  checksum node[:mongodb][platform][:checksum]
  action :create_if_missing
end

[node[:mongodb][:dir], "#{node[:mongodb][:dir]}/bin", node[:mongodb][:datadir]].each do |dir|
  directory dir do
    owner "mongodb"
    group "mongodb"
    mode 0755
    recursive true
  end
end

bash "Setting up MongoDB #{node[:mongodb][:version]}" do
  cwd "/tmp"
  code <<-EOH
    tar -zxf mongodb-#{node[:mongodb][:version]}.tar.gz --strip-components=2 -C #{node[:mongodb][:dir]}/bin
  EOH
  not_if { `ps -A -o command | grep "[m]ongo"`.include? node[:mongodb][:version] }
end

environment = File.read('/etc/environment')
unless environment.include? node[:mongodb][:dir]
  File.open('/etc/environment', 'w') { |f| f.puts environment.gsub(/PATH="/, "PATH=\"#{node[:mongodb][:dir]}/bin:") }
end

file node[:mongodb][:logfile] do
  owner "mongodb"
  group "mongodb"
  mode 0644
  action :create_if_missing
  backup false
end

template node[:mongodb][:config] do
  source "mongodb.conf.erb"
  owner "mongodb"
  group "mongodb"
  mode 0644
  backup false
end

template "/etc/init.d/mongodb" do
  source "mongodb.init.erb"
  mode 0755
  backup false
end

service "mongodb" do
  supports :start => true, :stop => true, "force-stop" => true, :restart => true, "force-reload" => true, :status => true
  action [:enable, :start]
  subscribes :restart, resources(:template => node[:mongodb][:config])
  subscribes :restart, resources(:template => "/etc/init.d/mongodb")
end

template rs_config_path = File.join(File.dirname(node[:mongodb][:config]), 'replica_set.conf') do
  source 'replica_set.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables( :members => search(:node, "mongodb_replica_set_name:#{node[:mongodb][:replica_set][:name]}"))
  notifies :run, 'bash[replica_set_initiate]'
  notifies :run, 'bash[replica_set_reconfigure]'
end

mongo_client = "#{node[:mongodb][:dir]}/bin/mongo"

bash "replica_set_initiate" do
  action :nothing
  # only if replica sets are enabled, and we're the primary
  only_if { node[:mongodb][:replica_set][:enabled] && node[:mongodb][:replica_set][:primary] }
  # not if the rs is already configured.
  not_if "test $(echo -n 'x' ; #{node[:mongodb][:dir]}/bin/mongo --eval \"rs.status()['ok']\" --quiet) == 'x1'"
  user 'root'
  code <<-EOH
    # Run the replica set configuration.
    (cat #{rs_config_path} ; echo "rs.initiate(cfg);") | #{node[:mongodb][:dir]}/bin/mongo --quiet
  EOH
end

bash "replica_set_reconfigure" do
  action :nothing
  # only if replica sets are enabled, and we're the primary
  only_if { node[:mongodb][:replica_set][:enabled] && node[:mongodb][:replica_set][:primary] }
  # only if the rs is already configured.
  only_if "test $(echo -n 'x' ; #{node[:mongodb][:dir]}/bin/mongo --eval \"rs.status()['ok']\" --quiet) == 'x1'"
  user 'root'
  code <<-EOH
    # Run the replica set configuration.
    (cat #{rs_config_path} ; echo "rs.reconfig(cfg);") | #{node[:mongodb][:dir]}/bin/mongo --quiet
  EOH
end

