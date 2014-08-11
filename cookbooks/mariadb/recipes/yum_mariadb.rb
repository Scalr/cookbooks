include_recipe 'yum'

arch = node[:kernel][:machine] =~ /x86_64/ ? "amd64" : "x86"
yum_repository 'mariadb' do
    description 'Mariadb repo'
    baseurl     "http://yum.mariadb.org/#{node[:mariadb][:version]}/#{node[:platform]}#{node[:platform_version].to_i}-#{arch}"
    gpgkey      'https://yum.mariadb.org/RPM-GPG-KEY-MariaDB'
end
