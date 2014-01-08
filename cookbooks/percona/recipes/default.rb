package "mysql-server" do
  action :purge
end

package "iptables" do
	action :install
end

package "git" do
	action :install
end

include_recipe "repo"

case node[:platform]
when "ubuntu","debian","gcel"
	package "mysql-client" do
	  action :purge
	end

	if node[:platform] == "debian"
		version = '5.5'
	elsif node[:lsb][:release].to_f >= 12.04
		version = '5.5'
	else
		version = '5.1'
	end

	package "percona-server-server-#{version}" do
	  action :install
	  options "--no-install-recommends"
	end
	
	package "percona-server-client-#{version}"
	
	cookbook_file "/etc/mysql/my.cnf" do
	  source "my-medium.cnf"
          mode "0644"
	end

when "redhat","centos","oracle","amazon"

	package "mysql" do
	  action :purge
	end

	# postfix requires mysql-libs
	execute "rpm -e --nodeps mysql-libs" do
    	only_if "rpm -q mysql-libs"
	end
	
	if node[:platform_version].to_f >= 6.0
		version = '55'
	else
		version = '51'
	end

	yum_package "Percona-Server-server-#{version}" do
			action :install
			flush_cache [:before]
	end

	yum_package "Percona-Server-client-#{version}"

	cookbook_file "/etc/my.cnf" do
	  source "my-medium.cnf"
          mode "0644"
	end
end

service "mysql" do
	action [ :disable, :stop ]
end
