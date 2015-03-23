#
# Cookbook Name:: timezone-ii
# Recipe:: pld
#
# Copyright 2010, James Harton <james@sociable.co.nz>
# Copyright 2013, Lawrence Leonard Gilbert <larry@L2G.to>
# Copyright 2013, Elan Ruusamäe <glen@delfi.ee>
#
# Apache 2.0 License.
#

# Set timezone for PLD family:  Put the timezone string in plain text in
# /etc/sysconfig/timezone and then re-run the timezone service to pick it up.

template '/etc/sysconfig/timezone' do
  source 'timezone.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, 'service[timezone]', :immediately
end

service 'timezone' do
  action :nothing
end
