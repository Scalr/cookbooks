default['mysql']['package_server_name'] = 'mysql-server'

default['mysql']['version'] = '5.6' if platform?('ubuntu') and node['platform_version'].to_f >= 16.04


if node['mysql']['version'] == '5.6' and platform?('ubuntu') and
    node['platform_version'].to_f >= 14.04 then
    default['mysql']['package_client_name'] = 'mysql-client-5.6'
    default['mysql']['package_server_name'] = 'mysql-server-5.6'
elsif platform_family?("rhel")
    default['mysql']['package_client_name'] = 'mysql'
elsif platform_family?("debian")
    default['mysql']['package_client_name'] = 'mysql-client'
end
