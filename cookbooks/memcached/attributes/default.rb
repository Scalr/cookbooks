default["memcached"]["memory"] = 64
default["memcached"]["port"] = 11211
default["memcached"]["listen"] = "0.0.0.0"
default['memcached']['maxconn'] = 1024

case node['platform_family']
when 'rhel'
    default['memcached']['user'] = 'memcached'
when 'debian'
    default['memcached']['user'] = 'nobody'

end

is_debian_ge_8 = platform?("debian") && node["platform_version"].to_i >= 8
is_ubuntu_ge_18 = platform?("ubuntu") && node["platform_version"].to_i >= 18
is_rhel = platform_family?("rhel")

default['memcached']['libmemcached'] =
    if is_debian_ge_8 || is_ubuntu_ge_18 || is_rhel
        "libmemcached-dev"
    else
        "libmemcache-dev"
    end
