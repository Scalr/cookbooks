package "mysql-server" do
  action :purge
end


case node["platform_family"]
when 'debian'
    include_recipe 'mariadb::apt_mariadb'

	package "mysql-client" do
	  action :purge
	end

	package "mariadb-server" do
	  action :install
	  options "--no-install-recommends"
	end

	package "mariadb-client"

when 'rhel'
    include_recipe 'mariadb::yum_mariadb'

	package "mysql" do
	  action :remove
	end

	# postfix requires mysql-libs
	execute "rpm -e --nodeps mysql-libs" do
        only_if "rpm -q mysql-libs"
	end

	package "MariaDB-server"
	package "MariaDB-client"

	#cookbook_file "/etc/my.cnf" do
	#  source "my-medium.cnf"
    #      mode "0644"
	#end
end

service "mysql" do
	action [ :disable, :stop ]
end
