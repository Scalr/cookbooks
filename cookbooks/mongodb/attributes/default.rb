# MongoDB repo settings

default[:repository][:dir] = "/var/tmp/mongodb-src"
default[:repository][:name] = "git://github.com/mongodb/mongo.git"
default[:repository][:revision] = "r2.6.1"
default[:service][:name] = "mongodb"
default[:service][:stop_command] = "pgrep -l mongo | awk {print'$1'} | xargs -i{}  sudo kill {}"