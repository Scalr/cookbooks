default['postgresql']['version'] = '9.3'

case node['platform']
when "redhat", "centos"
    default['postgresql']['dir'] = "/var/lib/pgsql/#{node['postgresql']['version']}/data"
    default['postgresql']['service_name'] = "postgresql-#{node['postgresql']['version']}"
    default['postgresql']['packages'] = ["postgresql#{node['postgresql']['version'].split('.').join}",
                                                   "postgresql#{node['postgresql']['version'].split('.').join}-server",
                                                   "postgresql#{node['postgresql']['version'].split('.').join}-devel"]
when "debian", "ubuntu"
     default['postgresql']['dir'] = "/etc/postgresql/#{node['postgresql']['version']}/main"
     default['postgresql']['service_name'] = "postgresql"
     default['postgresql']['packages'] = ["postgresql-#{node['postgresql']['version']}"] 
     default['postgresql']['pgdg']['release_apt_codename'] = node['lsb']['codename']
end
