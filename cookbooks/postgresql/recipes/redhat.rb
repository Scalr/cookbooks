include_recipe 'postgresql::yum_pgdg_postgresql'

node['postgresql']['packages'].each do |pkg| 
    package pkg
end

execute "service #{node[:postgresql][:service_name]} initdb"

service "#{node[:postgresql][:service_name]} " do
  action [:disable, :stop]
end

execute "sed -i \"s/.*listen_addresses.*/listen_addresses = '*'/g\" #{node[:postgresql][:dir]}/postgresql.conf"
