#
# Cookbook Name:: timezone-ii
# Recipe:: default
#
# Copyright 2010, James Harton <james@sociable.co.nz>
# Copyright 2013, Lawrence Leonard Gilbert <larry@L2G.to>
#
# Apache 2.0 License.
#

log 'timezone setting' do
  message "Time zone setting: #{node.tz}"
  level :debug
end

# Make sure the tzdata database is installed. (Arthur David Olson, the computer
# timekeeping field is forever in your debt.)
package value_for_platform_family(
  'gentoo'  => 'timezone-data',
  'default' => 'tzdata'
)

if node.platform_family == 'debian'
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

elsif node.os == "linux"
  # Generic method for Linux that should work for any Linux distro. Since it's a
  # last resort for platforms that have no better way to change the timezone,
  # this will log a warning.  (No warning on RHEL-based platforms since this
  # seems to be the best current practice there.)
  log "fallback Linux" do
    message "Linux platform '#{node.platform}' is unknown to this recipe; " +
            "using fallback Linux method"
    level :warn
    not_if { %w( gentoo rhel ).include? node.platform_family }
  end

  timezone_data_file = File.join(node.timezone.tzdata_dir, node.tz)
  localtime_path = node.timezone.localtime_path

  ruby_block "confirm timezone" do
    block {
      unless File.exist?(timezone_data_file)
        raise "Can't find #{timezone_data_file}!"
      end
    }
  end

  if node.timezone.use_symlink
    link localtime_path do
      to timezone_data_file
      owner 'root'
      group 'root'
      mode 0644
    end

  else
    file localtime_path do
      content File.open(timezone_data_file, 'rb').read
      owner 'root'
      group 'root'
      mode 0644
      not_if {
        File.symlink?(localtime_path) and
          Chef::Log.error "You must remove symbolic link at #{localtime_path}" +
                          " or set attribute ['timezone']['use_symlink']=true"
      }
    end
  end  # if/else node.timezone.use_symlink

else
  log "unknown platform" do
    message "Don't know how to configure timezone for " +
            "'#{node.platform_family}'!"
    level :error
  end
end  # if/elsif/else platform-check

# vim:ts=2:sw=2:
