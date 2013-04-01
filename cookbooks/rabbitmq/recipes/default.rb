case node[:platform]
when "ubuntu","debian"
	cookbook_file "/etc/apt/sources.list.d/rabbitmq.list"
	remote_file "/tmp/rabbitmq-signing-key-public.asc" do
		source "http://www.rabbitmq.com/rabbitmq-signing-key-public.asc"
		mode "0644"
	end
	execute "apt-key add /tmp/rabbitmq-signing-key-public.asc"
	execute "apt-get update"
	
	if node[:lsb][:release].to_f == 8.04
		cookbook_file "/etc/apt/sources.list.d/karmic.list"
		execute "apt-get update"
		# Rabbitmq-server depends on erlang-nox package
		# other erlang dependencies will be installed automatically
		execute "apt-get -t karmic install erlang-nox"
		
		file "/etc/apt/sources.list.d/karmic.list" do
			action :delete
		end
	end
	
	package "rabbitmq-server"
end