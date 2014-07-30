default[:x11vnc] = {
  :password => ""
}

default[:x11vnc][:display] = ':99'
default[:x11vnc][:log_file] = '/var/log/x11vnc'
default[:x11vnc][:executable_args] = '-nowf -nopw  -xkb'

