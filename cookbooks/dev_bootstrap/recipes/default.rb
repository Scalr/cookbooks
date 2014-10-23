#
# Cookbook Name:: scalarizr
# Recipe:: default
#
# Copyright 2012, Scalr Inc.
#
# All rights reserved - Do Not Redistribute
#
include_recipe "epel"

case node["platform_family"]
when "debian"
    if not (platform?("ubuntu") and node["platform_version"] == '14.10')
        # old version
        execute "cd /tmp && wget http://apt.scalr.net/scalr-repository_0.3_all.deb && dpkg -i /tmp/scalr-repository_0.3_all.deb && rm -f /tmp/scalr-repository_0.3_all.deb"
        execute "apt-get update"
        execute "rm -rf /etc/apt/sources.list.d/scalr*"
        cookbook_file "/etc/apt/sources.list.d/scalr-stable.list" do
            source "scalr-stable.list"
            mode "0644"
        end
        execute "apt-get update"
        package "scalarizr-devtools"
    else
        # new version
        # switch once strider is ready
        include_recipe "apt"
        apt_repository "scalr-branch" do
            uri "http://stridercd.scalr-labs.com/apt/develop"
            components ["feature-omnibus-integration", "main"]
            keyserver "keyserver.ubuntu.com"
            key "04B54A2A"
        end

        package "scalarizr"
    end

when "rhel"
    if node["platform_version"] < "6.0"
        yum_package "python26"
    end

    if not (platform?("centos") and node["platform_version"].to_i == 7)
        # old version
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
        # new version
        # switch once strider is ready
        include_recipe "yum"
        yum_repository "scalr-branch" do
            description "Scalr repo"
            baseurl "http://stridercd.scalr-labs.com/rpm/feature-omnibus-integration/rhel/$releasever/$basearch"
            gpgcheck false 
            action :create
        end

        package "scalarizr"
    end
end

package "vim"
# Install pip
remote_file "/tmp/get-pip.py" do
    source "https://bootstrap.pypa.io/get-pip.py"
end
bash "ipython install" do
    code <<-EOS
        python /tmp/get-pip.py
        pip install ipython==1.2.1
    EOS
end

