#
# Cookbook Name:: scalarizr
# Recipe:: default
#
# Copyright 2010, Scalr Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "epel"
include_recipe "yum" if platform_family?("rhel")
include_recipe "apt" if platform_family?("debian")


case node["scalarizr"]["branch"]
when "stable", "candidate"
    # Installing stable repo
    case node["platform_family"]
    when "rhel"
        yum_repository "scalr" do
            description "Scalr repo"
            baseurl "http://rpm-delayed.scalr.net/rpm/rhel/$releasever/$basearch/"
            gpgcheck false
            action :create
        end
    when "debian"
        apt_repository "scalr" do
            uri "http://apt-delayed.scalr.net/debian/"
            distribution "scalr/"
            keyserver "keyserver.ubuntu.com"
            key "04B54A2A"
        end
    end

    if node["scalarizr"]["branch"] == "candidate"
        # XXX: legacy code for installing candidate branch from buildbot.
        # Remove this and go with normal branch installing once the new candidate hits strider.
        case node["platform_family"]
        when "debian"
            execute "echo 'deb http://buildbot.scalr-labs.com/apt/debian #{node[:scalarizr][:branch]}/' > /etc/apt/sources.list.d/scalr-branch.list"
            bash 'pin_repo' do
                code <<-EOH
                echo -e 'Package: *\nPin: release a=#{node[:scalarizr][:branch]}\nPin-Priority: 1001\n' > /etc/apt/preferences
                EOH
                not_if "grep -q #{node[:scalarizr][:branch]} /etc/apt/preferences"
            end
            execute "apt-get update"
        when "rhel"
            package "yum-plugin-priorities" do
                if node[:platform_version].to_f < 6
                    package_name "yum-priorities"
                end
            end
            baseurl = "http://buildbot.scalr-labs.com/rpm/#{node[:scalarizr][:branch]}/rhel/$releasever/$basearch"
            if node[:platform] == "fedora"
                baseurl = "http://buildbot.scalr-labs.com/rpm/#{node[:scalarizr][:branch]}/fedora/$releasever/$basearch"
            end
            execute "echo -e '[scalr-#{node[:scalarizr][:branch]}]\nname=scalr branch\n' > /etc/yum.repos.d/scalr-branch.repo"
            execute "echo -e 'baseurl=#{baseurl}\nenabled=1\ngpgcheck=0\npriority=10' >> /etc/yum.repos.d/scalr-branch.repo"
            execute "yum clean all"
        end
    end
when "latest"
    case node["platform_family"]
    when "rhel"
        yum_repository "scalr" do
            description "Scalr repo"
            baseurl "http://repo.scalr.net/rpm/latest/rhel/$releasever/$basearch/"
            gpgcheck false
            action :create
        end
    when "debian"
        apt_repository "scalr" do
            uri "http://repo.scalr.net/apt" 
            distribution "latest"
            components ["main"]
            keyserver "keyserver.ubuntu.com"
            key "04B54A2A"
        end
    end
else
    # Installing development branch from strider
    case node["platform_family"]
    when "rhel"
        yum_repository "scalr-devel" do
            description "Scalr development repo"
            baseurl "http://stridercd.scalr-labs.com/rpm/#{node[:scalarizr][:branch]}/rhel/$releasever/$basearch/"
            gpgcheck false
            action :create
        end
    when "debian"
        apt_repository "scalr-devel" do
            uri "http://stridercd.scalr-labs.com/apt/develop/"
            distribution node["scalarizr"]["branch"]
            components ["main"]
            keyserver "keyserver.ubuntu.com"
            key "04B54A2A"
        end
    end
end

if platform_family?("rhel")
     if node["platform_version"] < "6.0"
         package "python26"
     end

    if platform?("amazon") && node["platform_version"] == '2014.03' &&
        ['stable', 'candidate'].include?(node["scalarizr"]["branch"])
        yum_package "python-boto" do
           options "--disablerepo='*' --enablerepo='scalr'"
           flush_cache [:before]
           action :upgrade
        end
    end

    yum_package "scalarizr-#{node[:scalarizr][:platform]}" do
       options "-x exim"
       flush_cache [:before]
    end
else # debian
    package "scalarizr-#{node[:scalarizr][:platform]}"
end

if node["scalarizr"]["behaviour"].include?("app")
    case node["platform_family"]
    when "debian"
        execute "cp #{node['scalarizr']['html_files']} /var/www/"
    when "rhel"
        execute "cp #{node['scalarizr']['html_files']} /var/www/html/"
    end
end

execute "scalarizr -y --configure -o behaviour=#{node[:scalarizr][:behaviour].join(',')} -o platform=#{node[:scalarizr][:platform]}"
