name             'x11vnc'
maintainer       'John Goulah'
maintainer_email 'jgoulah@gmail.com'
license          'BSD'
description      'Installs/Configures x11vnc'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.6'

%w{ ubuntu debian centos }.each do |os|
  supports os
end

depends          'yum-epel'

recommends       'loco_xvfb'
