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
	package "epel-release" do
		action :purge 
		only_if "rpm -q epel-release"
	end

	arch = node[:kernel][:machine]  =~ /x86_64/ ? "x86_64" : "i386"

	if node[:platform_version].to_f >= 6.0 or node[:platform] == "amazon"
		epel_rpm = "http://dl.fedoraproject.org/pub/epel/6/#{arch}/epel-release-6-8.noarch.rpm"
	else
		epel_rpm = "http://dl.fedoraproject.org/pub/epel/5/#{arch}/epel-release-5-4.noarch.rpm"
	end

	remote_file "/tmp/epel.rpm" do
		source epel_rpm
		mode "0644"
	end

	package "epel" do
		action :install
		source "/tmp/epel.rpm"
		provider Chef::Provider::Package::Rpm
		not_if 
	end

end