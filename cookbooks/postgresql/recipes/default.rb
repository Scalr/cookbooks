#
# Cookbook Name:: postgresql
# Recipe:: default
#
# Copyright 2011, Scalr Inc.
#
# All rights reserved - Do Not Redistribute
#

case node["platform_family"]
when "rhel"
  include_recipe "postgresql::redhat"
when "debian"
  include_recipe "postgresql::debian"
end
