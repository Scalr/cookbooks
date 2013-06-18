

package "mysql-server" do
  action :purge
end

case node[:platform]
when "ubuntu", "debian"
	package "mysql-client" do
	  action :purge
	end

	execute "request mariadb key" do
	  command "apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db"
	  not_if "apt-key list | grep 1BB943DB"
	end
	
	execute "apt-get update" do
	  action :nothing
	end

	template "/etc/apt/sources.list.d/mariadb.list" do
  		source "mariadb.list.erb"
  		mode "0644"
  		variables( :codename => node[:lsb][:codename])
		notifies :run, resources("execute[apt-get update]"), :immediately
	end

	package "mariadb-server" do
	  action :install
	  options "--no-install-recommends"
	end

	package "mariadb-client"


when "redhat", "centos", "oracle", "amazon"

	package "mysql" do
	  action :purge
	end

	# postfix requires mysql-libs
	execute "rpm -e --nodeps mysql-libs" do
    only_if "rpm -q mysql-libs"
	end
	
	yum_package "gpg"

	arch = node[:kernel][:machine]  =~ /x86_64/ ? "amd64" : "x86"
	platform = node[:platform] == "redhat" ? "rhel" : "centos"

	template "/etc/yum.repos.d/mariadb.repo" do
		source "mariadb.repo.erb"
		mode = "0644"
		variables(
			:arch => arch,
			:platform => platform
		)
	end

	yum_package "MariaDB-server" do
		action :install
		flush_cache [:before]
	end

	yum_package "MariaDB-client"

	#cookbook_file "/etc/my.cnf" do
	#  source "my-medium.cnf"
    #      mode "0644"
	#end
end

service "mysql" do
	action [ :disable, :stop ]
end
