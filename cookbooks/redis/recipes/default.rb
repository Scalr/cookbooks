if node["redis"]["version"]
    include_recipe "redis::versioned_install"
else
    include_recipe "redis::regular_install"
end

if platform_family?("rhel")
    cookbook_file "/etc/redis.conf" do
        source node["redis"]["config_file"]
        owner "redis"
        group "redis"
    end
end

service node["redis"]["service_name"] do
    action [:disable, :stop]
end
