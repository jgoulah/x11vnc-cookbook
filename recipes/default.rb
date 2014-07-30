#
# Cookbook Name:: x11vnc
# Recipe:: default

package "x11vnc"

if node["platform_family"] == "rhel"
  template "/etc/init.d/x11vnc" do
    source "x11vnc.init.d.erb"
    mode 00755
    variables(
      :display => node[:x11vnc][:display],
      :log_file => node[:x11vnc][:log_file],
      :executable_args => node[:x11vnc][:executable_args]
    )
  end
end

service "x11vnc" do
  action [:enable, :start]
  provider Chef::Provider::Service::Upstart
end

password_opt = ""
unless node[:x11vnc][:password].empty?
  password_opt = "-rfbauth /etc/x11vnc.pass"

  execute "gen x11vnc password file" do
    command "x11vnc -storepasswd #{node[:x11vnc][:password]} /etc/x11vnc.pass"
  end
end

template "/etc/init/x11vnc.conf" do
  source "x11vnc.conf.erb"
  mode 00644
  variables(
    :password_opt => password_opt
  )
end

