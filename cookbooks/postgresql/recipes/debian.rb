execute "apt-get update" do
  action :nothing
end

if node[:platform] == "ubuntu" and node[:lsb][:release].to_f < 11.10
	cookbook_file "/etc/apt/sources.list.d/pitti-postgresql-precise.list"
	execute "apt-get update"
end

if node[:platform] == "debian" and node[:platform_version].to_f < 7.0
	cookbook_file "/etc/apt/sources.list.d/squeeze-backports.list"
	execute "apt-get update" 
	execute "apt-get install -y -t squeeze-backports postgresql-9.1"
else
	package "postgresql-9.1"
	package "postgresql-client-9.1"
end


service "postgresql" do
  action [:disable, :stop]
end

execute "sed -i \"s/.*listen_addresses.*/listen_addresses = '*'/g\" /etc/postgresql/9.1/main/postgresql.conf"