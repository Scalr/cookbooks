#
# Cookbook Name:: scalarizr
# Recipe:: default
#
# Copyright 2010, Scalr Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "epel"
include_recipe "yum" if platform_family?("rhel")
include_recipe "apt" if platform_family?("debian")

case node["platform_family"]
when "rhel"
    yum_repository node['scalarizr']['repo_name'] do
        description "Scalr repo"
        baseurl node['scalarizr']['baseurl']
        gpgcheck false
        action :create
    end
when "debian"
    apt_repository node['scalarizr']['repo_name'] do
        uri node['scalarizr']['uri']
        distribution node['scalarizr']['distribution']
        keyserver "keyserver.ubuntu.com"
        key "04B54A2A"
    end
end

if platform_family?("rhel")
     if node["platform_version"] < "6.0"
         package "python26"
     end

     yum_package "python-boto" do
         options "--disablerepo='*' --enablerepo='scalr'"
         flush_cache [:before]
         action :upgrade
         only_if { platform?("amazon") && node["platform_version"] == '2014.03' &&
                   ['stable', 'candidate'].include?(node["scalarizr"]["branch"]) }
     end

    yum_package "scalarizr-#{node['scalarizr']['platform']}" do
       options "-x exim"
       flush_cache [:before]
    end
else # debian
    package "scalarizr-#{node['scalarizr']['platform']}"
end

execute "copy html" do
    # Support two versions of the share directory until February 2015
    environment lazy {{"SOURCE_DIR" => File.exist?("/opt/scalarizr/share/") ? "/opt/scalarizr/share/apache/html/*" : "/usr/share/scalr/apache/html/*",
                       "DEST_DIR"   => platform_family?("debian") ? "/var/www/" : "/var/www/html/"}}
    command "cp $SOURCE_DIR $DEST_DIR"
    only_if { node["scalarizr"]["behaviour"].include?("app") }
end
