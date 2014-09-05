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
    package "mysql" do
      action :remove
    end

    # postfix requires mysql-libs
    execute "rpm -e --nodeps mysql-libs" do
        only_if "rpm -q mysql-libs"
    end

    # XXX: Disable this check once the official MariaDB repo for Centos 7 is available
    if platform?("centos") && node["platform_version"].to_i == 7
        package "mariadb-server"
        package "mariadb"
    else
        include_recipe 'yum'

        yum_repository 'mariadb' do
            description 'Mariadb repo'
            baseurl     node["mariadb"]["yum_repo_url"]
            gpgkey      'https://yum.mariadb.org/RPM-GPG-KEY-MariaDB'
        end

        package "MariaDB-server"
        package "MariaDB-client"
    end

    #cookbook_file "/etc/my.cnf" do
    #  source "my-medium.cnf"
    #      mode "0644"
    #end
end

service "mysql" do
    action [:disable, :stop]
end
