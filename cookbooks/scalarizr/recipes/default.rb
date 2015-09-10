#
# Cookbook Name:: scalarizr
# Recipe:: default
#
# Copyright 2010, Scalr Inc.
#
# All rights reserved - Do Not Redistribute
#

remote_file node['scalarizr']['script_path'] do
    source node['scalarizr']['script_url']
    mode 700
end

execute "installing scalarizr" do
    command node['scalarizr']['script_path']
end

execute "copy html" do
    # Support two versions of the share directory until February 2015
    environment lazy {{"SOURCE_DIR" => File.exist?("/opt/scalarizr/share/") ? "/opt/scalarizr/share/apache/html/*" : "/usr/share/scalr/apache/html/*",
                       "DEST_DIR"   => platform_family?("debian") ? "/var/www/" : "/var/www/html/"}}
    command "cp $SOURCE_DIR $DEST_DIR"
    only_if { node["scalarizr"]["behaviour"].include?("app") }
end
