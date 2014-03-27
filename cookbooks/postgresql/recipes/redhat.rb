arch = node[:kernel][:machine]  =~ /x86_64/ ? "x86_64" : "i386"
platform_version = node[:platform] == "amazon" ? "6.4" : node[:platform_version].to_i 
package_release = ["redhat", "oracle", "amazon"].include?(node[:platform]) ? 7 : 6
package_os = node[:platform] == "centos" ? "centos" : "redhat"
    
remote_file "/tmp/pgdg-9.rpm" do
  source "http://yum.postgresql.org/9.3/redhat/rhel-#{platform_version}-#{arch}/pgdg-#{package_os}93-9.3-1.noarch.rpm"
end

rpm_package "/tmp/pgdg-9.rpm"

package "postgresql93"
package "postgresql93-server"
package "postgresql93-devel"


execute "service postgresql-9.3 initdb"

service "postgresql-9.3" do
  action [:disable, :stop]
end

execute "sed -i \"s/.*listen_addresses.*/listen_addresses = '*'/g\" /var/lib/pgsql/9.3/data/postgresql.conf"
