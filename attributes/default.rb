default['x11vnc'] = {
  :password => ''
}
default['x11vnc']['display'] = ':0'
default['x11vnc']['log_file'] = '/var/log/x11vnc'
default['x11vnc']['executable_args'] = '-nowf -nopw -xkb -xkb '
default['x11vnc']['executable_args'] << '-noxrecord -noxfixes '
default['x11vnc']['executable_args'] << '-noxdamage -forever'
