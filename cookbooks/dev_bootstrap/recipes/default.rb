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
  if not (node[:platform] == 'centos' and node[:platform_version].to_i == 7)
    execute "rpm -Uvh http://rpm.scalr.net/rpm/scalr-release-2-1.noarch.rpm" do
        not_if "rpm -q scalr-release-2-1.noarch"
    end

    execute "rm -rf /etc/yum.repos.d/scalr*"

    cookbook_file "/etc/yum.repos.d/scalr-stable.repo" do
          	  source "scalr-stable.repo"
               mode "0644"
    end
    yum_package "scalarizr-devtools"
  else
    %w{python-devel wget openssh}.each do |pkg|
      package pkg do
        action :upgrade
      end
    end
    remote_file "/tmp/scalarizr.rpm" do
		source "http://stridercd.scalr.ws/rpm/feature-omnibus-integration/rhel/7Server/x86_64/scalarizr-2.9.b5622.b7ce53a6-1.x86_64.rpm"
		mode "0644"
	end
	remote_file "/tmp/scalarizr-ec2.rpm" do
		source "http://stridercd.scalr.ws/rpm/feature-omnibus-integration/rhel/7Server/x86_64/scalarizr-ec2-2.9.b5622.b7ce53a6-1.x86_64.rpm"
		mode "0644"
	end
	package "scalarizr" do
		action :install
		source "/tmp/scalarizr.rpm"
		provider Chef::Provider::Package::Rpm
	end
  end

end

package "vim"
bash "ipython install" do
    code <<-EOS
    wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
    python /tmp/get-pip.py
    pip install ipython
	EOS
end
