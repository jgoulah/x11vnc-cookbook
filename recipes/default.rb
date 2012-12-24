#
# Cookbook Name:: x11vnc
# Recipe:: default

package "x11vnc"

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

