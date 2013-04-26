include_recipe "epel"
  
case node[:platform]
when "ubuntu","debian"
	package "python-software-properties"
	execute "apt-add-repository -y ppa:chris-lea/redis-server"
	execute "apt-get update" 
	package "redis-server"
	
	service "redis-server" do
		action [ :disable, :stop ]
	end

when "redhat","centos","oracle","amazon"
	arch = node[:kernel][:machine]  =~ /x86_64/ ? "x86_64" : "i386"
  	
  	if node[:platform_version].to_f >= 6.0 or node[:platform] == "amazon"
		execute "rpm -Uvh --replacepkgs http://centos.alt.ru/repository/centos/6/#{arch}/centalt-release-6-1.noarch.rpm"
	else
		execute "rpm -Uvh --replacepkgs http://centos.alt.ru/repository/centos/5/#{arch}/centalt-release-5-3.noarch.rpm"
	end

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