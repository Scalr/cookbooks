#
# Cookbook Name:: epel
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


case node[:platform]
when "redhat","centos","oracle","scientific","amazon"

	epel_rpm = "http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm"

	if node[:platform_version].to_f < 6.0
		epel_rpm = "http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm"
	end

  
	remote_file "/tmp/epel.rpm" do
		source epel_rpm
		mode "0644"
	end

	package "epel" do
		action :install
		source "/tmp/epel.rpm"
		provider Chef::Provider::Package::Rpm
	end
	
end