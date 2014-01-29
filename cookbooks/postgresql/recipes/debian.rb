execute "apt-get update" do
  action :nothing
end

if node[:platform] == "debian" or (node[:platform] == "ubuntu" and [14.04, 13.10, 12.04, 10.04].include?(node[:lsb][:release].to_f))
        version = 9.2
        if node[:lsb][:codename] == "saucy"
            codename = "trusty"
        else
            codename = node[:lsb][:codename]
        end
        execute "wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -"
        template "/etc/apt/sources.list.d/pgdg.list" do
                source "pgdg.list.erb"
                mode "0644"
                variables( :codename => codename)
                notifies :run, resources("execute[apt-get update]"), :immediately
        end
elsif node[:platform] == "ubuntu" and node[:lsb][:release].to_f > 12.04
        version = 9.2
else
        version = 9.1
end

package "postgresql-#{version}"
package "postgresql-client-#{version}"

service "postgresql" do
  action [:disable, :stop]
end

execute "sed -i \"s/.*listen_addresses.*/listen_addresses = '*'/g\" /etc/postgresql/#{version}/main/postgresql.conf"