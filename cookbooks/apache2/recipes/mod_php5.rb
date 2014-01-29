#
# Cookbook Name:: apache2
# Recipe:: php5 
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
when "debian", "ubuntu"
  package "libapache2-mod-php5"
  package "php5-cli"
  package "php5-mysql"
  if node[:platform] == "ubuntu" and node[:platform_version].to_f < 13.10
    package "php5-suhosin" do
      action :install
      ignore_failure true
    end
  end


when "centos", "redhat", "oracle", "amazon"
  if node[:platform] == "centos" and node[:platform_version].to_f < 6.0
    php = "php53"
  else
    php = "php"
  end

  package "#{php}"
  package "#{php}-mysql"
end
