#!/bin/bash
$(ohai | /opt/chef/embedded/bin/ruby -rjson -e 'ohai_data = JSON.load($stdin.read); ohai_data.each {|key, value| next unless /^platform/.match(key); puts "export ohai_#{key}=#{value}"}')
