include_recipe 'postgresql::apt_pgdg_postgresql'

node['postgresql']['packages'].each do |pkg|
    package pkg
end

service "#{node['postgresql']['service_name']}" do
  action [:disable, :stop]
end

execute "sed -i \"s/.*listen_addresses.*/listen_addresses = '*'/g\" #{node[:postgresql][:dir]}/postgresql.conf"
