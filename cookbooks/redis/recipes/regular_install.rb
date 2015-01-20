include_recipe "epel"
include_recipe "apt"

case node["platform"]
when "ubuntu"
    apt_repository 'redis-ppa' do
        uri 'http://ppa.launchpad.net/chris-lea/redis-server/ubuntu'
        distribution node['lsb']['codename']
        components ['main']
        keyserver 'keyserver.ubuntu.com'
        key 'C7917B12'
    end

    package "redis-server"

when "debian"
    version = node["platform_version"].to_f

    if 6.0 <= version and version < 7.0
        cookbook_file "/etc/apt/sources.list.d/squeeze-backports.list"
        execute "apt-get update" 
        execute "apt-get install -y -t squeeze-backports redis-server" 
    elsif version >= 7
        cookbook_file "/etc/apt/sources.list.d/wheezy-backports.list"
        execute "apt-get update"
        execute "apt-get install -y -t wheezy-backports redis-server"
    end

when "redhat","centos","oracle","amazon","scientific"
    if not (["redhat", "centos"].include?(node["platform"]) and node["platform_version"].to_i == 7)
        platform_version = platform?("amazon") ? 6 : node["platform_version"].to_i
        package_url = "https://s3.amazonaws.com/scalr-labs/packages/redis-2.8.9-1.el#{platform_version}.x86_64.rpm"
        path = "/tmp/#{File.basename(package_url)}"

        remote_file path do
            source package_url
        end

        rpm_package "redis" do
            source path
            action :install
        end
    else
        package "redis"
    end

    cookbook_file "/etc/redis.conf" do
        owner "redis"
        group "redis"
    end
end
