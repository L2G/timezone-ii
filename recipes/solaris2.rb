execute "set_timezone" do
  command "svccfg -s timezone:default setprop timezone/localtime= astring: #{node['tz']}; svcadm refresh timezone:default"
  not_if "svccfg -s timezone:default listprop timezone/localtime | grep #{node['tz']}"
  action :run
end

