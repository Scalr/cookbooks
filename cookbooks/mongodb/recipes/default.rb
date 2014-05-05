case node[:platform]
when "ubuntu", "debian","gcel"
	execute "apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10"
	
	cookbook_file "/etc/apt/sources.list.d/10gen.list" do
		mode "0644"
		if node[:platform] == 'debian'
			source "10gen-debian.list"
		end
	end

    execute "apt-get update"

	package "mongodb-10gen"	
	
	service "mongodb" do
		action [ :disable, :stop ]
	end
	
when "redhat","centos","oracle","amazon"
	if ['i686', 'i586', 'i386'].include?(node[:kernel][:machine])
		arch = "x86"
	else
		arch = "x64"
	end
	
	cookbook_file "/etc/yum.repos.d/10gen.repo" do
		source "10gen_#{arch}.repo"
		mode "0644"
	end
	
	yum_package "mongo-10gen-server" do
		flush_cache [:before]
	end
	
	service "mongod" do
		action [ :disable, :stop ]
	end

end




