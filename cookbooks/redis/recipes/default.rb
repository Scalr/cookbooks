include_recipe "epel"
  
case node[:platform]
when "ubuntu"
	
	execute "apt-get update" do
	  action :nothing
	end

	template "/etc/apt/sources.list.d/chris-lea-redis-server.list" do
  		source "chris-lea-redis-server.list.erb"
  		mode "0644"
		variables(:codename => node[:lsb][:codename])
  		notifies :run, resources("execute[apt-get update]"), :immediately
	end

	package "redis-server" do
		action :install
		options "--force-yes"
	end
	
	service "redis-server" do
		action [ :disable, :stop ]
	end

when "debian"
	version = node[:platform_version].to_f

	if 6.0 <= version and version < 7.0
		cookbook_file "/etc/apt/sources.list.d/squeeze-backports.list"
		execute "apt-get update" 
		execute "apt-get install -y -t squeeze-backports redis-server" 
	elsif version >= 7 
		package "redis-server"
	end

	service "redis-server" do
		action [ :disable, :stop ]
	end
		

when "redhat","centos","oracle","amazon"

	include_recipe "epel"

	yum_package "redis" do
		flush_cache [:before]
	end
	
	service "redis" do
		action [ :disable, :stop ]
	end

	cookbook_file "/etc/redis.conf" do
		owner "redis"
		group "redis"
	end


end