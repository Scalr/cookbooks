arch = node[:kernel][:machine]  =~ /x86_64/ ? "x86_64" : "i386"
platform_version = node[:platform] == "amazon" ? "6.4" : node[:platform_version].to_i 
package_release = ["redhat", "oracle", "amazon"].include?(node[:platform]) ? 5 : 4
package_os = node[:platform] == "centos" ? "centos" : "redhat"
    
remote_file "/tmp/pgdg-9.rpm" do
	source "http://yum.pgrpms.org/9.1/redhat/rhel-#{platform_version}-#{arch}/pgdg-#{package_os}91-9.1-#{package_release}.noarch.rpm"
end

rpm_package "/tmp/pgdg-9.rpm"

=begin
ruby_block "Exclude postgres from base" do
  block do
    case node.platform
    when "redhat"
     repocfg_paths = ["/etc/yum/pluginconf.d/rhnplugin.conf"]
     sections = ["main"]
    when "centos"
     repocfg_paths = ["/etc/yum.repos.d/CentOS-Base.repo"]
     sections = ["base", "updates"]
    when "fedora"
      repocfg_paths = ["/etc/yum.repos.d/fedora.repo", "/etc/yum.repos.d/fedora-updates.repo"]
      sections = ["fedora"]
    end
    
    regexp = Regexp.new("(\\[(" + sections.join("|") + ")\\][^\\[]*)")
    
    for cfg in repocfg_paths
      if not FileTest.exists?(cfg)
	next
      end
      repo =  File.open(cfg, 'r').read
      repo.gsub!(regexp, "\\1exclude=postgresql*\n")
      File.open(cfg, 'w') {|f| f.write(repo)}
    end
  end
  action :create
end
=end


package "postgresql91"
package "postgresql91-server"
package "postgresql91-devel"


execute "service postgresql-9.1 initdb"

service "postgresql-9.1" do
  action [:disable, :stop]
end

execute "sed -i \"s/.*listen_addresses.*/listen_addresses = '*'/g\" /var/lib/pgsql/9.1/data/postgresql.conf"
