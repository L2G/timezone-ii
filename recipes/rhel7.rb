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

template '/etc/sysconfig/clock' do
  source 'clock.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :run, 'execute[tzdata-update]'
end

execute 'tzdata-update' do
  command '/usr/sbin/tzdata-update'
  action :nothing
  # Amazon Linux doesn't have this command!
  only_if { ::File.executable?('/usr/sbin/tzdata-update') }
end
