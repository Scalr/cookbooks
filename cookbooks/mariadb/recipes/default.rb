package "mysql-server" do
  action :purge
end


case node["platform_family"]
when 'debian'
    include_recipe 'apt'

    apt_repository 'mariadb' do
        uri "http://mirrors.supportex.net/mariadb/repo/#{node['mariadb']['version']}/#{node['platform']}"
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

    # postfix requires mysql-libs or mariadb-libs
    %w{mysql-libs mariadb-libs}.each do |pkg|
        execute "rpm -e --nodeps #{pkg}" do
            only_if "rpm -q #{pkg}"
        end
    end

    include_recipe 'yum'
    yum_repository 'mariadb' do
        description 'Mariadb repo'
        baseurl     node["mariadb"]["yum_repo_url"]
        gpgkey      'https://yum.mariadb.org/RPM-GPG-KEY-MariaDB'
    end

    package "MariaDB-server"
    package "MariaDB-client"
    package "MariaDB-shared"

    #cookbook_file "/etc/my.cnf" do
    #  source "my-medium.cnf"
    #      mode "0644"
    #end
end

service "mysql" do
    action [:disable, :stop]
end
