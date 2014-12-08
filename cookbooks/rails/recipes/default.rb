#
# Cookbook Name:: django
# Recipe:: default
#
# Copyright 2011, Scalr Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"

case node["platform_family"]
when "debian"
    package "python-software-properties"
    execute "apt-add-repository ppa:brightbox/passenger"
    execute "apt-get update"
    package "libapache2-mod-passenger"
    cookbook_file "/etc/apache2/sites-available/default" do
        mode "0644"
    end
    execute "a2ensite default"

when "rhel"
    if node["kernel"]["machine"] == "i686"
        arch = "i386"
    else
        arch = node["kernel"]["machine"]
    end
    
    %w{openssl-devel curl-devel zlib-devel httpd-devel}.each do |pkg|
        package pkg do
            action :install
        end
    end
    
    gem_package "passenger" do
        version node["passenger"]["version"]
        action :install     
    end
    
    execute "passenger_module" do
        command 'passenger-install-apache2-module -a'
        creates node["passenger"]["module_path"]
    end
    
    template node["passenger"]["apache_conf_path"] do
        source "passenger.conf.erb"
        owner "root"
        group "root"
        mode 0755
    end     

    cookbook_file "/etc/httpd/conf.d/default.conf" do
        source "default"
        mode "0644"
    end
    
end

gem_package "rails" 

execute "new rails project" do
    command "rails new mysite"
    cwd "/home"
    action :run
end
