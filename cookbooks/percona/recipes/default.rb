

package "mysql-server" do
  action :purge
end

case node[:platform]
when "ubuntu","debian"
	package "mysql-client" do
	  action :purge
	end

	execute "request percona key" do
	  command "gpg --keyserver subkeys.pgp.net --recv-keys 1C4CBDCDCD2EFD2A"
	  not_if "gpg --list-keys CD2EFD2A"
	end

	execute "install percona key" do
	  command "gpg -a --export CD2EFD2A | apt-key add -"
	  not_if "apt-key list | grep CD2EFD2A"
	end

	execute "apt-get update" do
	  action :nothing
	end

	cookbook_file "/etc/apt/sources.list.d/percona.list" do
	  source "percona.list"
          mode "0644"
	  notifies :run, resources("execute[apt-get update]"), :immediately
	end
	
	if node[:lsb][:release].to_f >= 12.04
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

when "redhat","centos","oracle"

	package "mysql" do
	  action :purge
	end

	# postfix requires mysql-libs
	execute "rpm -e --nodeps mysql-libs" do
    only_if "rpm -q mysql-libs"
	end

	arch = node[:kernel][:machine]  =~ /x86_64/ ? "x86_64" : "i386"
	
	yum_package "gpg"

	execute "rpm -Uvh --replacepkgs http://www.percona.com/downloads/percona-release/percona-release-0.0-1.#{arch}.rpm"
	
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
