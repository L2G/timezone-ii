#
# Cookbook Name:: passenger
# Recipe:: install

gem_package "passenger/system" do
  package_name 'passenger'
  version node[:passenger][:version]
  not_if "test -e /usr/local/bin/rvm"
end

gem_package "passenger/rvm" do
  package_name 'passenger'
  version node[:passenger][:version]
  gem_binary "/usr/local/bin/rvm default exec gem"
  only_if "test -e /usr/local/bin/rvm"
end

gem_package "bundler/system" do
  package_name 'bundler'
  not_if "test -e /usr/local/bin/rvm"
end

gem_package "bundler/rvm" do
  package_name 'bundler'
  gem_binary "/usr/local/bin/rvm default exec gem"
  only_if "test -e /usr/local/bin/rvm"
end

rvm_exec_prefix = system("test -e /usr/local/rvm") ? "/usr/local/bin/rvm default exec" : ""
node.default[:passenger][:root_path] = `#{rvm_exec_prefix} passenger-config --root`.chomp 
node.default[:passenger][:module_path] = `#{rvm_exec_prefix} passenger-config --root`.chomp + "/ext/apache2/mod_passenger.so"
