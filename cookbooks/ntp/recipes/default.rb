#
# Cookbook Name:: ntp
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
when "redhat","centos","oracle","scientific","fedora","suse","amazon"
	packages = %w{ ntp }
	service_name = "ntpd"
else
	packages = %w{ ntp ntpdate }
	service_name = "ntp"
end


packages.each do |pkg|
  package pkg
end

service service_name do
  action [ :enable, :start ]
end