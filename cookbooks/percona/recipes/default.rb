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

    package "percona-server-server-#{node["percona"]["version"]}" do
        action :install
        options "--no-install-recommends"
    end

    package "percona-server-client-#{node["percona"]["version"]}"

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
end


service "mysql" do
    action [:disable, :stop]
end

# bug in debian: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=751638
#  need to disable the service manually
if node["platform"] == "debian" and node["platform_version"].to_i == 8
    execute "systemctl disable mysql"
end
