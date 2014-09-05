case node["platform_family"]
when "debian"
    unless platform?("debian") and node["platform_version"].to_i == 6
        package "libjemalloc1"
    end
when "rhel"
    #include_recipe "epel"
    #package "gperftools-libs" #provides libtcmalloc.so.4
end

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
