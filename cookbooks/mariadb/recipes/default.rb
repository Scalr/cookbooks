package "mysql-server" do
  action :purge
end


case node["platform_family"]
when 'debian'
    include_recipe 'apt'

    apt_repository 'mariadb' do
        uri "http://mirrors.supportex.net/mariadb/repo/#{node[:mariadb][:version]}/#{node[:platform]}"
        distribution node['lsb']['codename']
        components ['main']
        keyserver 'keyserver.ubuntu.com'
        key '0xcbcb082a1bb943db'
        action :add
    end

	package "mysql-client" do
	  action :purge
	end

	package "mariadb-server" do
	  action :install
	  options "--no-install-recommends"
	end

	package "mariadb-client"

when 'rhel'
    include_recipe 'yum'

    arch = node[:kernel][:machine] =~ /x86_64/ ? "amd64" : "x86"
    yum_repository 'mariadb' do
        description 'Mariadb repo'
        baseurl     "http://yum.mariadb.org/#{node[:mariadb][:version]}/#{node[:platform]}#{node[:platform_version].to_i}-#{arch}"
        gpgkey      'https://yum.mariadb.org/RPM-GPG-KEY-MariaDB'
    end

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
