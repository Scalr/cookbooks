#
# Cookbook Name:: apache2
# Recipe:: python 
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node[:platform]
when "debian","ubuntu"
	package "libapache2-mod-rpaf"

when "redhat","centos","oracle"
	remote_file "/tmp/scalr-release-2-1.noarch.rpm" do
		source "http://rpm.scalr.net/rpm/scalr-release-2-1.noarch.rpm"
		mode "0644"
	end

	package "scalr" do
		action :install
		source "/tmp/scalr-release-2-1.noarch.rpm"
		provider Chef::Provider::Package::Rpm
	end

	yum_package "mod_rpaf" do
		action :install
		flush_cache [:before]
	end
	
	cookbook_file "/etc/httpd/conf.d/mod_rpaf.conf" do
		source "mod_rpaf.conf"
		mode 0755
		owner "root"
		group "root"
	end
end