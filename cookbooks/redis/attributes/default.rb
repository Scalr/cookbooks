default["redis"]["cache_dir"] = "/tmp"
default["redis"]["version"] = "2.8"

default["redis"]["packages"] = {"2.4" =>
                                {"ubuntu" => ["https://s3.amazonaws.com/scalr-labs/packages/redis-server_2.4.18-rwky1~oneiric_amd64.deb"],
                                 "debian" => ["https://s3.amazonaws.com/scalr-labs/packages/redis-server_2.4.15-1~bpo60%2B2_amd64.deb"],
                                 "rhel5" => ["https://s3.amazonaws.com/scalr-labs/packages/redis-2.4.10-1.el5.x86_64.rpm"],
                                 "rhel6" => ["https://s3.amazonaws.com/scalr-labs/packages/redis-2.4.10-1.el6.x86_64.rpm"]},
                                "2.6" =>
                                 {"ubuntu" => ["https://s3.amazonaws.com/scalr-labs/packages/redis-server_2.6.13-1chl1~oneiric1_amd64.deb"],
                                  "debian" => ["https://s3.amazonaws.com/scalr-labs/packages/libjemalloc1_3.3.1-1.squeeze_amd64.deb",
                                               "https://s3.amazonaws.com/scalr-labs/packages/redis-server_2.6.13-1~bpo70%2B1%2Bb1_amd64.deb"],
                                  "rhel5" => ["https://s3.amazonaws.com/scalr-labs/packages/jemalloc-3.6.0-2.el5.x86_64.rpm", 
                                              "https://s3.amazonaws.com/scalr-labs/packages/redis-2.6.16-1.el5.x86_64.rpm"],
                                  "rhel6" => ["https://s3.amazonaws.com/scalr-labs/packages/redis-2.6.13-1.el6.x86_64.rpm"]},
                                "2.8" =>
                                 {"ubuntu" => ["https://s3.amazonaws.com/scalr-labs/packages/redis-server_2.8.19-rwky1~lucid_amd64.deb",],
                                  "debian" => ["https://s3.amazonaws.com/scalr-labs/packages/libjemalloc1_3.0.0-3_amd64.deb",
                                               "https://s3.amazonaws.com/scalr-labs/packages/init-system-helpers_1.18~bpo70%2B1_all.deb",
                                               "https://s3.amazonaws.com/scalr-labs/packages/redis-tools_2.8.17-1~bpo70%2B1%2Bb1_amd64.deb",
                                               "https://s3.amazonaws.com/scalr-labs/packages/redis-server_2.8.17-1~bpo70%2B1%2Bb1_amd64.deb",],
                                  "rhel5" => ["https://s3.amazonaws.com/scalr-labs/packages/jemalloc-3.6.0-2.el5.x86_64.rpm",
                                              "https://s3.amazonaws.com/scalr-labs/packages/redis-2.8.19-1.el5.remi.x86_64.rpm"],
                                  "rhel6" => ["https://s3.amazonaws.com/scalr-labs/packages/jemalloc-3.6.0-1.el6.x86_64.rpm",
                                              "https://s3.amazonaws.com/scalr-labs/packages/redis-2.8.19-1.el6.remi.x86_64.rpm"]},
                                "3.0" =>
                                {"ubuntu" => ["https://s3.amazonaws.com/scalr-labs/packages/libjemalloc1_3.6.0-1chl1~lucid1_amd64.deb",
                                              "https://s3.amazonaws.com/scalr-labs/packages/redis-tools_3.0.0-1chl1~lucid1_amd64.deb",
                                              "https://s3.amazonaws.com/scalr-labs/packages/redis-server_3.0.0-1chl1~lucid1_amd64.deb"]}}
if node["redis"]["version"]
    default["redis"]["install_packages"] =
        case node["platform_family"]
        when "debian"
            node["redis"]["packages"].fetch(node["redis"]["version"]).fetch(node["platform"])
        when "rhel"
            platform = platform?("amazon") ? "rhel6" : "#{node["platform_family"]}#{node["platform_version"].to_i}"
            node["redis"]["packages"].fetch(node["redis"]["version"]).fetch(platform)
        end
end

default["redis"]["service_name"] =
    case node["platform_family"]
    when "debian"
        "redis-server"
    when "rhel"
        "redis"
    end

default["redis"]["config_file"] = 
    if node["redis"]["version"] && node["redis"]["version"].to_f <= 2.4
        "redis24.conf"
    else
        "redis.conf"
    end
