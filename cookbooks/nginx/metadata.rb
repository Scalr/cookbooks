maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures nginx"
version           "0.14.3"

recipe "nginx", "Installs nginx package and sets up configuration with Debian apache style with sites-enabled/sites-available"

%w{ ubuntu debian centos redhat fedora oracle}.each do |os|
  supports os
end
