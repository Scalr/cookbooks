#
# Cookbook Name:: scalarizr
# Recipe:: default
#
# Copyright 2010, Scalr Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe "epel"

case node[:platform]
when "debian","ubuntu","gcel"
	execute "cd /tmp && wget http://apt.scalr.net/scalr-repository_0.3_all.deb && dpkg -i /tmp/scalr-repository_0.3_all.deb && rm -f /tmp/scalr-repository_0.3_all.deb"
	execute "apt-get update"
when "redhat","centos","oracle","amazon","scientific"

  if node[:platform_version] < "6.0"
	yum_package "python26"
  end

  execute "rpm -Uvh http://rpm.scalr.net/rpm/scalr-release-2-1.noarch.rpm" do
    not_if "rpm -q scalr-release-2-1.noarch"
  end
end


if node[:scalarizr][:branch] == 'stable'
	case node[:platform]
	when "debian","ubuntu","gcel"
		execute "sed -i 's/^/#/' /etc/apt/sources.list.d/scalr-latest.list"
		execute "sed -i 's/^#\\+//' /etc/apt/sources.list.d/scalr-stable.list"
		execute "apt-get update"
	when "redhat","centos","fedora","oracle","amazon","scientific"
		execute "sed -i 's/^/#/' /etc/yum.repos.d/scalr-latest.repo"
		execute "sed -i 's/^#\\+//' /etc/yum.repos.d/scalr-stable.repo"
		execute "yum clean all"
	end
	node.set[:scalarizr][:branch] = ""	
end


package "scalarizr-#{node[:scalarizr][:platform]}" do
  case node[:platform]
  when "redhat","centos","oracle","amazon","scientific"
	 options "-x exim --disableplugin=priorities"
  end
end 


if node[:scalarizr][:platform] == 'gce'
	case node[:platform]
  	when "redhat","centos","oracle","scientific"
  		package "python-devel"
  		package "openssl-devel"
  	when "gcel","ubuntu","debian"
  		package "python-dev"
  		package "libssl-dev"
  	end
	package "python-setuptools"
	execute "/usr/bin/easy_install --upgrade pyopenssl"
end


if !node[:scalarizr][:branch].empty? 
	package "scalarizr" do
		action :purge
	end
	package "scalarizr-#{node[:scalarizr][:platform]}" do
		action :purge
	end
	package "scalarizr-base" do
		action :purge
	end
	node[:scalarizr][:branch].gsub!('/', '-')
	node[:scalarizr][:branch].gsub!('.', '')
	
	case node[:platform]
	when "debian","ubuntu","gcel"
		execute "echo 'deb http://buildbot.scalr-labs.com/apt/debian #{node[:scalarizr][:branch]}/' > /etc/apt/sources.list.d/scalr-latest.list"
		execute "apt-get update"
		package "scalarizr-#{node[:scalarizr][:platform]}"
	when "redhat","centos","fedora","oracle","amazon","scientific"
		baseurl = "baseurl=http:\\/\\/buildbot\\.scalr-labs\\.com\\/rpm\\/#{node[:scalarizr][:branch]}\\/rhel\\/\\$releasever\\/\\$basearch"
		if node[:platform] == "fedora"
			baseurl = "baseurl=http:\\/\\/buildbot\\.scalr-labs\\.com\\/rpm\\/#{node[:scalarizr][:branch]}\\/fedora\\/\\$releasever\\/\\$basearch"
		end
		
		execute "yum clean all"
		execute "sed -i 's/baseurl=.*$/#{baseurl}/g' /etc/yum.repos.d/scalr-latest.repo"
		
		yum_package "scalarizr-#{node[:scalarizr][:platform]}" do
			flush_cache [ :before ]
			options ("--disableplugin=priorities")
			action :install
		end
	end
end

if node[:scalarizr][:dev] == "1"
	execute "cp /etc/scalr/logging-debug.ini /etc/scalr/logging.ini"
end


if node[:scalarizr][:behaviour].include?("app")
  case node[:platform]
  when "debian","ubuntu","gcel"
    execute "cp /usr/share/scalr/apache/html/* /var/www/"
  when "redhat","centos","oracle","amazon","scientific"
    execute "cp /usr/share/scalr/apache/html/* /var/www/html/"
  end
end

behaviours=node[:scalarizr][:behaviour].join(",")
execute "scalarizr -y --configure -o behaviour=" + behaviours + " -o platform=" + node[:scalarizr][:platform]
execute "scalr-upd-client -r stable"

