#
# Cookbook Name:: timezone
# Recipe:: default
#
# Copyright 2010, James Harton <james@sociable.co.nz>
# Copyright 2013, Lawrence Leonard Gilbert <larry@L2G.to>
#
# Apache 2.0 License.
#

# Make sure the tzdata database is installed. (Arthur David Olson, the computer
# timekeeping field is forever in your debt.)
package "tzdata"

case node.platform_family
when 'debian'
  # On Debian, Ubuntu, et al., put the timezone string in plain text in
  # /etc/timezone and then re-run the tzdata configuration to pick it up.
  template "/etc/timezone" do
    source "timezone.conf.erb"
    owner 'root'
    group 'root'
    mode 0644
    notifies :run, 'bash[dpkg-reconfigure tzdata]'
  end

  bash 'dpkg-reconfigure tzdata' do
    user 'root'
    code "/usr/sbin/dpkg-reconfigure -f noninteractive tzdata"
    action :nothing
  end

when 'rhel'
  # On RedHat Enterprise, Amazon Linux, CentOS, et al., the compiled timezone
  # data has to be copied out of the /usr/share/zoneinfo tree directly.
  file '/etc/localtime' do
    content File.open(File.join('/usr/share/zoneinfo', node.tz), 'rb').read
    owner 'root'
    group 'root'
    mode 0644
  end

else
  Chef::Log.error "Don't know how to configure timezone for " +
    "'#{node.platform_family}' family!"
end

# vim:ts=2:sw=2:
