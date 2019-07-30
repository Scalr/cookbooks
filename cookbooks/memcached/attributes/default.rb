default["memcached"]["memory"] = 64
default["memcached"]["port"] = 11211
default["memcached"]["listen"] = "0.0.0.0"
default['memcached']['maxconn'] = 1024

case node['platform_family']
when 'rhel'
    default['memcached']['user'] = 'memcached'
    default['memcached']['libmemcached'] = "libmemcached-devel"
when 'debian'
    default['memcached']['user'] = 'nobody'
    default['memcached']['libmemcached'] =
        if platform?("debian") && node["platform_version"].to_i >= 8
                "libmemcached-dev"
        elsif platform?("ubuntu") && node["platform_version"].to_i >= 18
                "libmemcached-dev"
        else
            "libmemcache-dev"
        end
end

