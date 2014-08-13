case node["platform_family"]
when "debian"
    include_recipe 'apt'
    platform = platform?("ubuntu") ? "ubuntu-upstart" : "debian-sysvinit"
    apt_repository 'mongodb' do
        uri "http://downloads-distro.mongodb.org/repo/#{platform}"
        distribution 'dist'
        components ['10gen']
        keyserver 'hkp://keyserver.ubuntu.com:80'
        key '7F0CEB10'
        action :add
    end

    node["mongodb"]["install_packages"].each do |pkg|
        package pkg do
            version node["mongodb"]["full_versions"][node["mongodb"]["version"]]
            action :install
        end
    end

when "rhel"
    include_recipe 'yum'
    arch = node[:kernel][:machine] =~ /x86_64/ ? 'x86_64' : 'i686'
    yum_repository  'mongodb' do
        description 'Mongodb repo'
        baseurl     "http://downloads-distro.mongodb.org/repo/redhat/os/#{arch}"
        action      :create
        gpgcheck    false
        enabled     true
    end

    if node["mongodb"]["version"] && node["mongodb"]["version"].to_f < 2.6
        pkgs = node["mongodb"]["install_packages"].join(" ")
        # We have to install it this way because old 'mongo-10gen' packages are
        # obsoleted by mongodb-org in the repo.
        execute "yum -y install #{pkgs} --exclude mongodb-org,mongodb-org-server"
    else
        node["mongodb"]["install_packages"].each do |pkg|
            package pkg
        end
    end
end

service node["mongodb"]["service_name"] do
    action [:disable, :stop]
end
