package "mysql-server" do
  action :purge
end

package "iptables" do
    action :install
end

package "git" do
    action :install
    not_if "which git"
end


include_recipe "percona::repo"

case node["platform_family"]
when "debian"
    package "mysql-client" do
      action :purge
    end

    package "percona-server-server-#{node[:percona][:version]}" do
        action :install
        options "--no-install-recommends"
    end

    package "percona-server-client-#{node[:percona][:version]}"

    cookbook_file "/etc/mysql/my.cnf" do
        source "my-medium.cnf"
        mode "0644"
    end

when "rhel"
    package "mysql" do
      action :purge
    end

    # postfix requires mysql-libs
    execute "rpm -e --nodeps mysql-libs" do
        only_if "rpm -q mysql-libs"
    end

    version = node["percona"]["version"].sub(/\./, '')

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
    action [:disable, :stop]
end
