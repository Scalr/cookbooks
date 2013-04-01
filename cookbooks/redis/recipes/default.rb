include_recipe "epel"
  
case node[:platform]
when "ubuntu","debian"
	remote_file "/tmp/scalr-repository_0.2_all.deb" do
		source "http://apt.scalr.net/scalr-repository_0.2_all.deb"
		mode "0644"
	end
	
	package "scalr" do
		action :install
		source "/tmp/scalr-repository_0.2_all.deb"
		provider Chef::Provider::Package::Dpkg
	end
	
	execute "apt-get update" 
	execute "apt-get -t 'scalr' install redis-server"
	service "redis-server" do
		action [ :disable, :stop ]
	end

when "redhat","centos","oracle"
  
	if node[:platform_version].to_f < 6.0
		remote_file "/tmp/scalr-release-2-1.noarch.rpm" do
			source "http://rpm.scalr.net/rpm/scalr-release-2-1.noarch.rpm"
			mode "0644"
		end
		package "scalr" do
			action :install
			source "/tmp/scalr-release-2-1.noarch.rpm"
			provider Chef::Provider::Package::Rpm
		end
	end
	package "redis"
	service "redis" do
		action [ :disable, :stop ]
	end
end