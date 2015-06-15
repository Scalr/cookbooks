default["rabbitmq"]["version"] = "3.5"
default["rabbitmq"]["packages"] = {"3.3" =>
                                   {"debian" => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server_3.3.5-1_all.deb",
                                    "rhel"   => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server-3.3.5-1.noarch.rpm"},
                                    "3.4" =>
                                   {"debian" => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server_3.4.2-1_all.deb",
                                    "rhel"   => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server-3.4.2-1.noarch.rpm"},
                                    "3.5" =>
                                   {"debian" => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server_3.5.3-1_all.deb",
                                    "rhel"   => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server-3.5.3-1.noarch.rpm"}}

default["rabbitmq"]["cache_dir"] = "/tmp"

default["rabbitmq"]["package_url"] = node["rabbitmq"]["packages"].fetch(node["rabbitmq"]["version"]).fetch(node["platform_family"])
default["rabbitmq"]["package_path"] = File.join(node["rabbitmq"]["cache_dir"], node["rabbitmq"]["package_url"].split('/')[-1])
default["rabbitmq"]["package_provider"] = 
    case node["platform_family"]
    when "debian"
        Chef::Provider::Package::Dpkg
    when "rhel"
        Chef::Provider::Package::Rpm
    end
