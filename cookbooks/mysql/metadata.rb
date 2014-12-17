maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures mysql for client or server"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.24.4"
name              "mysql"
recipe            "mysql", "Includes the client recipe to configure a client"
recipe            "mysql::client", "Installs packages required for mysql clients using run_action magic"
recipe            "mysql::server", "Installs packages required for mysql servers w/o manual intervention"
%w{ debian ubuntu centos suse fedora redhat oracle}.each do |os|
  supports os
end

depends "openssl"
