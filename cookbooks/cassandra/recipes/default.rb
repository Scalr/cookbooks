#
# Cookbook Name:: cassandra
# Recipe:: default
#
# Copyright 2011, Scalr Inc.
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
when "debian","ubuntu"
  cookbook_file "/etc/apt/sources.list.d/cassandra.list" do
    source "cassandra.list"
    mode "0644"
  end
  execute "gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D"
  execute "gpg --export --armor F758CE318D77295D | sudo apt-key add -"
  execute "apt-get update"
  package "cassandra"
when "redhat","centos","oracle"
  execute "rpm -Uvh http://rpm.riptano.com/EL/6/x86_64/riptano-release-5-1.el6.noarch.rpm"
  package "java-1.6.0-openjdk"
  package "apache-cassandra"
end