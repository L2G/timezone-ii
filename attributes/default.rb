default[:tz] = 'UTC'

# Path to tzdata directory
default['timezone']['tzdata_dir'] = '/usr/share/zoneinfo'

# Path to file used by kernerl for local timezone's data
default['timezone']['localtime_path'] = '/etc/localtime'

# Whether to use a symlink to tzdata (instead of copying)
default['timezone']['use_symlink'] = false
