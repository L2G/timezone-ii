#
# Cookbook Name:: passenger
# Recipe:: production

include_recipe "passenger::install"

package "curl"
if ['ubuntu', 'debian'].member? node[:platform]
  ['libcurl4-openssl-dev','libpcre3-dev'].each do |pkg|
    package pkg
  end
end

nginx_path = node[:passenger][:production][:path]

bash "install passenger/nginx" do
  user "root"
  code <<-EOH
  passenger-install-nginx-module --auto --auto-download --prefix="#{nginx_path}" --extra-configure-flags="#{node[:passenger][:production][:configure_flags]}"
  EOH
  not_if "test -e #{nginx_path}"
  not_if "test -e /usr/local/rvm"
end

bash "install passenger/nginx from rvm" do
  user "root"
  code <<-EOH
  /usr/local/bin/rvm exec passenger-install-nginx-module --auto --auto-download --prefix="#{nginx_path}" --extra-configure-flags="#{node[:passenger][:production][:configure_flags]}"
  EOH
  not_if "test -e #{nginx_path}"
  only_if "test -e /usr/local/rvm"
end

log_path = node[:passenger][:production][:log_path]

directory log_path do
  mode 0755
  action :create
end

directory "#{nginx_path}/conf/conf.d" do
  mode 0755
  action :create
  recursive true
  notifies :reload, 'service[passenger]'
end

directory "#{nginx_path}/conf/sites.d" do
  mode 0755
  action :create
  recursive true
  notifies :reload, 'service[passenger]'
end

cookbook_file "#{nginx_path}/sbin/config_patch.sh" do
  owner "root"
  group "root"
  mode 0755
end

bash "config_patch" do
  # The big problem is that we can't compute the gem install path
  # because we don't know what ruby version we're being installed
  # on if RVM is present.
  user "root"
  code "#{nginx_path}/sbin/config_patch.sh #{nginx_path}/conf/nginx.conf.unpatched #{nginx_path}/conf/nginx.conf"
  action :nothing
  #only_if "egrep '##(PASSENGER_ROOT||RUBY_PATH)##' #{nginx_path}/conf/nginx.conf"
  notifies :restart, 'service[passenger]'
end

template "#{nginx_path}/conf/nginx.conf.unpatched" do
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :log_path => log_path,
    :passenger_root => "##PASSENGER_ROOT##",
    :ruby_path => "##RUBY_PATH##",
    :passenger => node[:passenger][:production],
    :pidfile => "#{nginx_path}/logs/nginx.pid"
  )
  notifies :run, 'bash[config_patch]'
end

template "/etc/init.d/passenger" do
  source "passenger.init.erb"
  owner "root"
  group "root"
  mode 0755
  variables(
    :pidfile => "#{nginx_path}/logs/nginx.pid",
    :nginx_path => nginx_path
  )
end

if node[:passenger][:production][:status_server]
  cookbook_file "#{nginx_path}/conf/sites.d/status.conf" do
    source "status.conf"
    mode "0644"
  end
end

service "passenger" do
  service_name "passenger"
  enabled true
  running true
  reload_command "#{nginx_path}/sbin/nginx -s reload"
  start_command "#{nginx_path}/sbin/nginx"
  stop_command "#{nginx_path}/sbin/nginx -s stop"
  status_command "curl http://localhost/nginx_status"
  supports [ :start, :stop, :reload, :status, :enable ]
  action [ :enable, :start ]
  pattern "nginx: master"
end

include_recipe "logrotate"

logrotate_app "passenger" do
  path "#{node[:passenger][:production][:log_path]}/*.log #{node[:passenger][:production][:log_path]}/*/*.log"
  rotate 12
end
