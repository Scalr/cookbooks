#
# Cookbook Name:: postgresql
# Recipe:: default
#
# Copyright 2011, Scalr Inc.
#
# All rights reserved - Do Not Redistribute
#



case node.platform
when "redhat", "centos", "fedora", "oracle","amazon"
  include_recipe "postgresql::redhat"
when "debian", "ubuntu"
  include_recipe "postgresql::debian"
end