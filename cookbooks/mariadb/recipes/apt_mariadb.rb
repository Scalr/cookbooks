include_recipe 'apt'

apt_repository 'mariadb' do
    uri "http://mirrors.supportex.net/mariadb/repo/#{node[:mariadb][:version]}/#{node[:platform]}"
    distribution node['lsb']['codename']
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key '0xcbcb082a1bb943db'
    action :add
end
