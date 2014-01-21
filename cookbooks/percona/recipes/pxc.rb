#
# Cookbook Name:: pxc
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

package "mysql-server" do
	action :purge
end


include_recipe "percona::repo"

case node[:platform]
when "ubuntu","debian","gcel"
	["mysql-client", "mysql-common"].each do |p|
		package p do
			action :purge
		end
	end
	package "percona-xtradb-cluster-server-5.5"
when "redhat","centos","oracle","amazon"
	package "Percona-XtraDB-Cluster-server-55"
end

service "mysql" do
	action [ :disable, :stop ]
end