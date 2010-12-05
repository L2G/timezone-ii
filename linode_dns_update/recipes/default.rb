gem_package 'linode' do
  #not_if "test -e /usr/local/bin/rvm-gem.sh"
end

gem_package "linode" do
  gem_binary "/usr/local/rvm/wrappers/default/gem"
  only_if "test -e /usr/local/rvm/wrappers/default/gem"
end


template '/root/.linode.yml' do
  owner 'root'
  group 'root'
  mode 0600
  source 'linode.yml.erb'
  only_if { node[:linode][:api_key] }
end

cookbook_file '/usr/local/bin/update_linode_dns.rb' do
  owner 'root'
  group 'root'
  mode 0755
end

# Flagrant debianism.
package 'bind9-host'

bash 'update_external_dns' do
  user 'root'
  only_if "test -e /usr/local/bin/update_linode_dns.rb"
  only_if "test -e /root/.linode.yml"
  only_if "test $( host -t A #{node[:fqdn]} | awk '{print \"x\" $4}' ) == 'x#{node[:ipaddress]}'"
  code "/usr/local/bin/update_linode_dns.rb #{node[:fqdn]} #{node[:ipaddress]}"
end

# FIXME: patch to handle EC2 internal addresses too.
#bash 'update_internal_dns' do
#  user 'root'
#  only_if "test -e /usr/local/bin/update_linode_dns.rb"
#  only_if "test -e /root/.linode.yml"
#  only_if { node[:rackspace] }
#  internal_hostname = "#{node[:hostname]}.int.rs.#{node[:domain]}"
#  internal_address = node[:rackspace][:private_ip]
#  only_if "test $( host -t A #{internal_hostname} | awk '{print \"x\" $4}' ) == 'x#{internal_address}'"
#  code "/usr/local/bin/update_linode_dns.rb #{internal_hostname} #{internal_address}"
#end
