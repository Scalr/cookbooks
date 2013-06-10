#
# Cookbook Name:: apache2
# Recipe:: default
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

package "apache2" do
  case node[:platform]
  when "centos","redhat","oracle","fedora","suse","amazon"
    package_name "httpd"
  when "debian","ubuntu"
  	if node[:platform] == 'debian' and node[:platform_version].to_f < 7
  		execute "wget http://ftp.us.debian.org/debian/pool/main/s/ssl-cert/ssl-cert_1.0.32_all.deb && dpkg -i ssl-cert_1.0.32_all.deb"
  	end
    package_name "apache2"
  end
  action :install
end

service "apache2" do
	case node[:platform]
	when "redhat","centos","oracle","scientific","fedora","suse","amazon"
		service_name "httpd"
	when "debian","ubuntu"
		service_name "apache2"
	end
	
	action [ :disable, :stop ]
end

include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_rpaf"
include_recipe "apache2::mod_php5"
