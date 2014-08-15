maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures tomcat"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.10.3"


%w{ debian ubuntu centos redhat fedora oracle}.each do |os|
  supports os
end

recipe "tomcat::default", "Installs and configures Tomcat"
name   "tomcat"
depends "epel"
