default['mysql']['package_server_name'] = 'mysql-server'

if node['mysql']['version'] == '5.6' && node['platform'] == 'ubuntu' &&
   node['platform_version'] == '14.04'
    default['mysql']['package_client_name'] = 'mysql-client-5.6'
    default['mysql']['package_server_name'] = 'mysql-server-5.6'
elsif platform?("centos", "redhat", "oracle")
    default['mysql']['package_client_name'] = 'mysql'
elsif platform?("ubuntu", "debian")
    default['mysql']['package_client_name'] = 'mysql-client'
end
