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

bash 'update_linode_dns' do
  user 'root'
  only_if "test -e /usr/local/bin/update_linode_dns.rb"
  only_if "test -e /root/.linode.yml"
  code "/usr/local/bin/update_linode_dns.rb"
end
