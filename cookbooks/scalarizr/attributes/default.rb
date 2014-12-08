default[:scalarizr][:behaviour] = [ "base" ]
default[:scalarizr][:platform]  = "ec2"
default[:scalarizr][:branch] = "latest"
# Empty branch string also means we want latest
node.override["scalarizr"]["branch"] = "latest" if node["scalarizr"]["branch"].strip.empty?

# Support two versions of the share directory until February 2015
default["scalarizr"]["html_files"] = File.exist?("/opt/scalarizr/share/apache/html/") ? "/opt/scalarizr/share/apache/html/*" : "/usr/share/scalr/apache/html/*"
