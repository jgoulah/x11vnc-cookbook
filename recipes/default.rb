#
# Cookbook Name:: x11vnc
# Recipe:: default

package 'x11vnc'

password_opt = ''
unless node['x11vnc']['password'].empty?
  password_file = '/etc/x11vnc.pass'
  password_opt = "-rfbauth #{password_file}"

  execute 'gen x11vnc password file' do
    command "x11vnc -storepasswd #{node['x11vnc']['password']} #{password_file}"
    not_if { ::File.exist?(password_file) }
  end
end

case node['platform_family']
when 'rhel'
  include_recipe 'yum-epel'
  file_target = '/etc/init.d/x11vnc'
  file_source = 'x11vnc.init.d.erb'
  file_mode =  00755
  service_provider = Chef::Provider::Service::Init::Redhat
else
  file_target = '/etc/init/x11vnc.conf'
  file_source = 'x11vnc.conf.erb'
  file_mode =  00644
  service_provider = Chef::Provider::Service::Upstart
end

template file_target do
  source file_source
  mode file_mode
  variables(
    :display         => node['x11vnc']['display'],
    :log_file        => node['x11vnc']['log_file'],
    :executable_args => node['x11vnc']['executable_args'],
    :password_opt    => password_opt,
    :template_file   => source.to_s,
    :recipe_file     => (__FILE__).to_s.split('cookbooks/').last
  )
  notifies(:restart, 'service[x11vnc]')
end

service 'x11vnc' do
  action [:enable, :start]
  provider service_provider
end
