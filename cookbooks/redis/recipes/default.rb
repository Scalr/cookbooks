node["redis"]["install_packages"].each do |pkg|
    path = File.join(node["redis"]["cache_dir"], pkg.split('/')[-1])
    provider = case node["platform_family"]
               when "debian"
                   Chef::Provider::Package::Dpkg
               when "rhel"
                   Chef::Provider::Package::Rpm end

    remote_file path do
        source pkg
    end

    package "redis" do
        source path
        provider provider
        action :install
    end
end

cookbook_file "/etc/redis.conf" do
    source node["redis"]["config_file"]
    owner "redis"
    group "redis"
    only_if { platform_family?("rhel") }
end

service node["redis"]["service_name"] do
    action [:disable, :stop]
end
