execute "apt-get update" do
  action :nothing
end

if node[:lsb][:release].to_f < 11.10
	package "python-software-properties"
	execute "add-apt-repository ppa:pitti/postgresql" do
	  notifies :run, resources("execute[apt-get update]"), :immediately
	end
end
package "postgresql-9.1"
package "postgresql-client-9.1"


service "postgresql" do
  action [:disable, :stop]
end

execute "sed -i \"s/.*listen_addresses.*/listen_addresses = '*'/g\" /etc/postgresql/9.1/main/postgresql.conf"