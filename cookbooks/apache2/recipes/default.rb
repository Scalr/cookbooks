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

include_recipe "apt" if platform_family?("debian")

if node["platform"] == 'debian' and node["platform_version"].to_f < 7 then
  execute "wget http://ftp.us.debian.org/debian/pool/main/s/ssl-cert/ssl-cert_1.0.32_all.deb && dpkg -i ssl-cert_1.0.32_all.deb"
end

package node["apache2"]["package_name"]

if not (['centos', 'redhat'].include?(node["platform"]) and node["platform_version"].to_i == 7) and
    not (node["apache2"]["package_name"] == "httpd24") then
    include_recipe "apache2::mod_rpaf"
end
include_recipe "apache2::mod_php"
include_recipe "apache2::mod_ssl"

service node["apache2"]["service_name"] do
    action [:disable, :stop]
end

# bug in debian: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=751638
# need to disable the service manually
if node["platform"] == "debian" and node["platform_version"].to_i == 8
    execute "systemctl disable apache2"
end
