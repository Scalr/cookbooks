#
# Cookbook Name:: scalarizr_proxy
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "nginx" do
  action :install
end

# Servers setup
template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
    :scalr_whitelist => node['scalarizr_proxy']['whitelist']
  })
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action :restart
end
