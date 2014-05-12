# MongoDB repo settings

default[:repository][:dir] = "/var/tmp/mongodb-src"
default[:repository][:name] = "git://github.com/mongodb/mongo.git"
default[:repository][:revision] = "r2.6.1"
default[:service][:name] = "mongodb"
default[:service][:stop_command] = "pgrep -l mongo | awk {print'$1'} | xargs -i{}  sudo kill {}"
default[:user][:name] = "mongodb"
default[:user][:home] = "/home/mongodb"
default[:user][:shell] = "/bin/false"
default[:user][:gid] = "nogroup"
default[:group][:name] = "mongodb"
default[:group][:members] = "mongodb"