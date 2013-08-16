require 'minitest/spec'

class TimezoneIiSpec < MiniTest::Chef::Spec

    describe_recipe 'timezone-ii::default' do

        it 'updates the timezone' do
            IO.read('/etc/localtime').must_equal IO.read("/usr/share/zoneinfo/#{node[:tz]}")
        end

    end

end
