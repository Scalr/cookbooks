#
# Cookbook Name:: epel
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

if platform_family?("rhel")
    include_recipe "yum"

    package "epel-release" do
        action :purge
        only_if "rpm -q epel-release"
    end

    yum_repository "epel" do
        description "EPEL repo"
        mirrorlist "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-#{node[:epel][:version]}&arch=$basearch"
        gpgkey "http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-#{node[:epel][:version]}"
        action :create
    end
end
