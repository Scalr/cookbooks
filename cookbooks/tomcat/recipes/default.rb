#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

version = node[:platform_version].to_f

case node.platform
#when "centos","redhat","fedora","oracle","amazon"
#  include_recipe "jpackage"
#end
when "ubuntu"
  if version >= 12.04
    tomcat = "tomcat7"
  else
    tomcat = "tomcat6"
  end
  tomcat_pkgs = [tomcat, "#{tomcat}-admin"]

when "debian"
  if version >= 7
    tomcat = "tomcat7"
  else
    tomcat = "tomcat6"
  end
  tomcat_pkgs = [tomcat, "#{tomcat}-admin"]

when "centos","redhat","fedora","oracle","amazon"
  include_recipe "epel"
  tomcat = "tomcat"
  tomcat_pkgs = [tomcat, "#{tomcat}-admin-webapps"]
end


tomcat_pkgs.each do |pkg|
  package pkg
end


service tomcat do
  action [ :disable, :stop ]
end