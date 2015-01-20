default['postgresql']['version'] = '9.3'
version = node["postgresql"]["version"]
dotless_version = version.split('.').join

case node['platform_family']
when "rhel"
    default['postgresql']['dir'] = "/var/lib/pgsql/#{version}/data"
    default['postgresql']['service_name'] = "postgresql-#{version}"
    default['postgresql']['packages'] = ["postgresql#{dotless_version}",
                                                   "postgresql#{dotless_version}-server",
                                                   "postgresql#{dotless_version}-devel"]
    default['postgresql']['initdb_command'] =  
        if ['centos', 'redhat'].include?(node['platform']) && node["platform_version"].to_i == 7
            "/usr/pgsql-#{version}/bin/postgresql#{dotless_version}-setup initdb"
        else
            "service #{node['postgresql']['service_name']} initdb" 
        end

    default['postgresql']['platform_version'] = platform?("amazon") ? 6 : node["platform_version"].to_i

when "debian"
     default['postgresql']['dir'] = "/etc/postgresql/#{version}/main"
     default['postgresql']['service_name'] = "postgresql"
     default['postgresql']['packages'] = ["postgresql-#{version}"] 
     default['postgresql']['pgdg']['release_apt_codename'] = node['lsb']['codename']
end
