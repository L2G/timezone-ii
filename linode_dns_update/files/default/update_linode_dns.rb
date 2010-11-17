#!/usr/bin/env ruby

require 'socket'
require 'rubygems'
require 'linode'

@linode = Linode.new(:api_key => (YAML::load_file File.expand_path('~/.linode.yml'))['linode']['api_key'])

my_host_name = ARGV[0]
my_address = ARGV[1]

def get_domain(hostname)
  chunked = hostname.split('.').reverse
  domains = @linode.domain.list
  (1..chunked.size).each do |i|
    zone = chunked[0..i].reverse * '.'
    domains.each do |domain|
      if domain.domain == zone
        return domain
      end
    end
  end
  nil
end

def get_node(fqdn, domain=nil)
  ((fqdn.split('.') - (domain||get_domain(fqdn)).split('.'))) * '.'
end

def get_rr(hostname, type, domain)
  @linode.domain.resource.list( 'DOMAINID' => domain.domainid ).each do |rr|
    return rr if rr.name == get_node(hostname, domain.domain) && rr.type == type
  end
  nil
end

if linode_domain = get_domain(my_host_name)
  if rr = get_rr(my_host_name, 'A', linode_domain)
    puts "Host #{my_host_name} found in zone #{linode_domain.domain}."
    if rr.target != my_address
      @linode.domain.resource.update  'DOMAINID' => linode_domain.domainid, 'RESOURCEID' => rr.resourceid, 'TARGET' => my_address
      puts "[updated] #{my_host_name} IN A #{my_address}"
    else
      puts "[noop]"
    end
  else
    @linode.domain.resource.create  'DOMAINID' => linode_domain.domainid, 'TYPE' => 'A', 'TARGET' => my_address, 'NAME' => get_node(my_host_name, linode_domain.domain)
    puts "[create] #{my_host_name} IN A #{my_address}"
  end
else
  puts "Error, no matching domain."
end
