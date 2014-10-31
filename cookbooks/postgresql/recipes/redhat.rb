include_recipe "yum"

yum_repository "PGDG" do
   description "Posgresql repo"
   baseurl     "http://yum.pgrpms.org/#{node[:postgresql][:version]}/redhat/rhel-#{node[:postgresql][:platform_version]}-$basearch"
   gpgkey      "http://yum.postgresql.org/RPM-GPG-KEY-PGDG"
   gpgcheck    true
   enabled     true
   action      :create
end

# Postgres depends on the latest version (as of 31.10.2014) because it fixes critical security bugs.
yum_package "openssl" do
    action :upgrade
end

node['postgresql']['packages'].each do |pkg| 
    yum_package pkg do
        options '--disablerepo="*" --enablerepo=PGDG'
    end
end

execute node["postgresql"]["initdb_command"]

service "#{node[:postgresql][:service_name]} " do
  action [:disable, :stop]
end

execute "sed -i \"s/.*listen_addresses.*/listen_addresses = '*'/g\" #{node[:postgresql][:dir]}/postgresql.conf"
