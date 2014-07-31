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
  template '/etc/init.d/x11vnc' do
    source 'x11vnc.init.d.erb'
    mode 00755
    variables(
      display: node['x11vnc']['display'],
      log_file: node['x11vnc']['log_file'],
      executable_args: node['x11vnc']['executable_args'],
      password_opt: password_opt
    )
    notifies(:restart, 'service[x11vnc]')
  end
else

  template '/etc/init/x11vnc.conf' do
    source 'x11vnc.conf.erb'
    mode 00644
    variables(
      password_opt: password_opt
    )
    notifies(:restart, 'service[x11vnc]')
  end
end

service 'x11vnc' do
  action [:enable, :start]
end
