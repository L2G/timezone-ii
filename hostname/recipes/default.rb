#
# Cookbook Name:: hostname
# Recipe:: default
#
# Copyright 2011, Sociable Limited

template "/etc/hostname" do
  source "hostname.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :run, "bash[reload_hostname]"
end

bash "reload_hostname" do
  user "root"
  code "hostname -F /etc/hostname"
  notifies :restart, "service[chef-client]"
end
