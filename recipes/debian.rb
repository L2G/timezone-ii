#
# Cookbook Name:: timezone-ii
# Recipe:: debian
#
# Copyright 2010, James Harton <james@sociable.co.nz>
# Copyright 2013, Lawrence Leonard Gilbert <larry@L2G.to>
#
# Apache 2.0 License.
#

# Set timezone for Debian family:  Put the timezone string in plain text in
# /etc/timezone and then re-run the tzdata configuration to pick it up.

TIMEZONE_FILE = '/etc/timezone'

template TIMEZONE_FILE do
  source "timezone.conf.erb"
  owner 'root'
  group 'root'
  mode 0644
  notifies :run, 'execute[dpkg-reconfigure-tzdata]'
end

execute 'dpkg-reconfigure-tzdata' do
  command '/usr/sbin/dpkg-reconfigure -f noninteractive tzdata'
  action :nothing
end

# Certain values get normalized by dpkg-reconfigure, causing this recipe to try
# to rewrite the file over and over.  This raises a red flag in such a case.
log 'if-unexpected-timezone-change' do
  message "dpkg-reconfigure is amending the value #{node['tz'].inspect} "\
          "in #{TIMEZONE_FILE}"
  level :warn
  not_if { ::File.read(TIMEZONE_FILE).chomp == node['tz'] }
  action :nothing
  subscribes :write, 'execute[dpkg-reconfigure-tzdata]', :immediately
end
