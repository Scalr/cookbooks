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
    bash "install scalr repo" do
        cwd "/tmp"
        code <<-EOH
            wget http://apt.scalr.net/scalr-repository_0.3_all.deb
            dpkg -i /tmp/scalr-repository_0.3_all.deb
            rm -f /tmp/scalr-repository_0.3_all.deb
            apt-get update
        EOH
        not_if "dpkg -l | grep -q scalr-repo"
    end

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
elsif node[:scalarizr][:branch].to_s.strip.empty?
    # Latest
    latest = true
else
    node[:scalarizr][:branch].gsub!('/', '-')
    node[:scalarizr][:branch].gsub!('.', '')

    case node[:platform]
    when "debian","ubuntu","gcel"
        execute "echo 'deb http://buildbot.scalr-labs.com/apt/debian #{node[:scalarizr][:branch]}/' > /etc/apt/sources.list.d/scalr-branch.list"

        bash 'pin_repo' do
            code <<-EOH
                echo -e 'Package: *\nPin: release a=#{node[:scalarizr][:branch]}\nPin-Priority: 1001\n' > /etc/apt/preferences
            EOH
            not_if "grep -q #{node[:scalarizr][:branch]} /etc/apt/preferences"
        end

        execute "apt-get update"
    when "redhat","centos","fedora","oracle","amazon","scientific"
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

case node[:platform]
when "redhat","centos","oracle","amazon","scientific"
    yum_package "scalarizr-#{node[:scalarizr][:platform]}" do
       options "-x exim"
       flush_cache [:before]
    end
else
    package "scalarizr-#{node[:scalarizr][:platform]}"
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

if defined? latest and latest
    execute "scalr-upd-client -r latest"
else
    execute "scalr-upd-client -r stable"
end

