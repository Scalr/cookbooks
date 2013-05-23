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

nginx_conf_dir = "/etc/nginx/conf.d"

# Servers setup
template "#{nginx_conf_dir}/scalarizr_gate.conf" do
  source "scalarizr_gate.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
    :scalr_whitelist => node['scalarizr_proxy']['whitelist']
  })
end

template "#{nginx_conf_dir}/scalr_gate.conf" do
  source "scalr_gate.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
    :scalr_ports => ["80"],
    :scalr_addr => node['scalarizr_proxy']['scalr_addr']
  })
end


service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action :restart
end
