include_recipe "epel"
include_recipe "apt"

case node[:platform]
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
	version = node[:platform_version].to_f

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
    execute "rpm -Uvh http://rpm.scalr.net/rpm/scalr-release-2-1.noarch.rpm" do
        not_if "rpm -q scalr-release-2-1.noarch"
    end

    yum_package "redis" do
        options = '--disablerepo="*" --enablerepo="scalr"'
    end

	cookbook_file "/etc/redis.conf" do
		owner "redis"
		group "redis"
	end
end

service node["redis"]["service_name"] do
    action [:disable, :stop]
end
