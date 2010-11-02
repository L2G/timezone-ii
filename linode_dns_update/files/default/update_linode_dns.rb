#!/usr/bin/env ruby

require 'socket'
require 'rubygems'
require 'linode'

@linode = Linode.new(:api_key => (YAML::load_file File.expand_path('~/.linode.yml'))['linode']['api_key'])

my_host_name = Socket.gethostbyname(Socket.gethostname).first
#my_host_name = 'hostname.tst.kimonoapp.com'

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

def get_rr(hostname, type, domain)
  node = ((hostname.split('.') - domain.domain.split('.'))) * '.'
  @linode.domain.resource.list( 'DOMAINID' => domain.domainid ).each do |rr|
    return rr if rr.name == 'node' && rr.type == type
  end
  nil
end

def get_local_ip
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

  UDPSocket.open do |s|
    s.connect '64.233.187.99', 1
    s.addr.last
  end
ensure
  Socket.do_not_reverse_lookup = orig
end

if linode_domain = get_domain(my_host_name)
  local_ip = get_local_ip
  node = ((my_host_name.split('.') - linode_domain.domain.split('.'))) * '.'
  if rr = get_rr(my_host_name, 'A', linode_domain)
    puts "Host #{my_host_name} found in zone #{linode_domain.domain}."
    if rr.target != local_ip
      @linode.domain.resource.update  'DOMAINID' => linode_domain.domainid, 'RESOURCEID' => rr.resourceid, 'TARGET' => local_ip
      puts "[updated] #{my_host_name} IN A #{local_ip}"
    else
      puts "[noop]"
    end
  else
    @linode.domain.resource.create  'DOMAINID' => linode_domain.domainid, 'TYPE' => 'A', 'TARGET' => local_ip, 'NAME' => node
    puts "[create] #{my_host_name} IN A #{local_ip}"
  end
else
  puts "Error, no matching domain."
end
