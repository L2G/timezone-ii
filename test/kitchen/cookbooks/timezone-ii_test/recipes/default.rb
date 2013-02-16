node.set[:timezone][:use_symlink] = false
node.set[:tz] = 'Africa/Timbuktu'
include_recipe 'timezone-ii'
