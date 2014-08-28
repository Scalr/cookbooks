include_recipe "yum"

yum_repository "PGDG" do
   description "Posgresql repo"
   baseurl     "http://yum.pgrpms.org/#{node[:postgresql][:version]}/redhat/rhel-$releasever-$basearch"
   gpgkey      "http://yum.postgresql.org/RPM-GPG-KEY-PGDG"
   gpgcheck    true
   enabled     true
   action      :create
end
   
node['postgresql']['packages'].each do |pkg| 
    package pkg
end

execute node["postgresql"]["initdb_command"]

service "#{node[:postgresql][:service_name]} " do
  action [:disable, :stop]
end

execute "sed -i \"s/.*listen_addresses.*/listen_addresses = '*'/g\" #{node[:postgresql][:dir]}/postgresql.conf"
