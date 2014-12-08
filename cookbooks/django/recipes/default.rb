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
    package "libapache2-mod-wsgi"
    package "python-pip"
when "rhel"
    if node["platform_version"].to_f < 6.0
        package "python26-mod_wsgi"
        execute "echo \"alias python='/usr/bin/python26'\" >> /root/.bash_profile"

        execute "wget http://pypi.python.org/packages/2.6/s/setuptools/setuptools-0.6c11-py2.6.egg#md5=bfa92100bd772d5a213eedd356d64086"
        execute "sh setuptools-0.6c11-py2.6.egg"
        file "/root/setuptools-0.6c11-py2.6.egg" do
            action :delete
        end
    else
        yum_package "mod_wsgi"
        yum_package "python-setuptools"
    end

    execute "easy_install pip"
end

execute "pip install django"

execute "new django project" do
    command "django-admin.py startproject mysite"
    cwd "/home"
    action :run
end

directory "/home/mysite/apache"
cookbook_file "/home/mysite/apache/django.wsgi" do
    mode "644"
end


case node["platform_family"]
when "debian"
    httpd_conf = "/etc/apache2/httpd.conf"
when "rhel"
    httpd_conf = "/etc/httpd/conf/httpd.conf"
end

execute "echo 'WSGIScriptAlias / /home/mysite/apache/django.wsgi' >> #{httpd_conf}"
