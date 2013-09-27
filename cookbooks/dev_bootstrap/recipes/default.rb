#
# Cookbook Name:: scalarizr
# Recipe:: default
#
# Copyright 2012, Scalr Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe "epel"

case node[:platform]
when "debian","ubuntu"
	execute "cd /tmp && wget http://apt.scalr.net/scalr-repository_0.3_all.deb && dpkg -i /tmp/scalr-repository_0.3_all.deb && rm -f /tmp/scalr-repository_0.3_all.deb"
    execute "apt-get update"
    execute "rm -rf /etc/apt/sources.list.d/scalr*"
    cookbook_file "/etc/apt/sources.list.d/scalr-stable.list" do
    	  source "scalr-stable.list"
              mode "0644"
    end
    execute "apt-get update"
    package "scalarizr-devtools"

when "redhat","centos","oracle","amazon"

  if node[:platform_version] < "6.0"
    yum_package "python26"
  end

  execute "rpm -Uvh http://rpm.scalr.net/rpm/scalr-release-2-1.noarch.rpm" do
    not_if "rpm -q scalr-release-2-1.noarch"
  end

  execute "rm -rf /etc/yum.repos.d/scalr*"

  cookbook_file "/etc/yum.repos.d/scalr-stable.repo" do
      	  source "scalr-stable.repo"
                mode "0644"
  end

  yum_package "scalarizr-devtools"

end

package "vim"
package "ipython"
