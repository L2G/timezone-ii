default.tz = 'UTC'

# Path to tzdata directory
case node.platform_family
when 'solaris2'
  default.timezone.tzdata_dir = '/usr/share/lib/zoneinfo'
else
  default.timezone.tzdata_dir = '/usr/share/zoneinfo'
end

# Path to file used by kernel for local timezone's data
default.timezone.localtime_path = '/etc/localtime'

# Whether to use a symlink to tzdata (instead of copying).
# Used only in the linux-default recipe.
default.timezone.use_symlink = false
