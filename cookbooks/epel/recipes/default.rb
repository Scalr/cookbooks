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

	if (node[:platform_version].to_f >= 6.0 and node[:platform_version].to_f < 7) or node[:platform] == "amazon"
		epel_rpm = "http://dl.fedoraproject.org/pub/epel/6/#{arch}/epel-release-6-8.noarch.rpm"
	elsif node[:platform] == 'centos' and node[:platform_version].to_i == 7
		epel_rpm = "http://dl.fedoraproject.org/pub/epel/7/#{arch}/e/epel-release-7-1.noarch.rpm"
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

	if (node[:platform_version].to_f >= 6.0 and node[:platform_version].to_f < 7) or node[:platform] == "amazon"
		cookbook_file "/etc/yum.repos.d/epel.repo" do
			source "epel-6.repo"
		end
	elsif node[:platform] == 'centos' and node[:platform_version].to_i == 7
	    bash "yum update" do
            code <<-EOS
            cd /etc/yum.repos.d/
        	rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7
        	yum update -y
	        EOS
	    end
	else
		cookbook_file "/etc/yum.repos.d/epel.repo" do
			source "epel-5.repo"
		end
	end
end