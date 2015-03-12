#
# Cookbook Name:: timezone-ii
# Recipe:: rhel
#
# Copyright 2013, fraD00r4 <frad00r4@gmail.com>
# Copyright 2015, Lawrence Leonard Gilbert <larry@L2G.to>
#
# Apache 2.0 License.
#

# This recipe sets the timezone on EL 6 and older (RedHat Enterprise Linux,
# CentOS, etc.)
#
# If it is being run on EL 7 or newer, the recipe will be skipped and
# the "rhel7" recipe will be included instead.

el_version = node[:platform_version].split('.')[0].to_i

if el_version >= 7
  include_recipe 'timezone-ii::rhel7'

else
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
end
