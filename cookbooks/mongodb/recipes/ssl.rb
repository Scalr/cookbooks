case node[:platform_family]
# Debian like os
when "debian"
    # Install requirements
	execute "sudo apt-get update && sudo apt-get install git-core build-essential scons libssl-dev -y"

# Red hat like os
when "rhel"
    # Install requirements
	execute "sudo yum install git scons gcc-c++ glibc-devel openssl-devel -y"
end

# Get source
git node[:repository][:dir] do
    repository node[:repository][:name]
    checkout_branch node[:repository][:revision]
    action :checkout
end

# Build from source
bash "install_mongodb" do
    cwd node[:repository][:dir]
    timeout 7200
    returns 0
    code <<-EOH
        sudo scons --ssl --64 all
        sudo scons install
    EOH
end

# Change service state
service "mongodb" do
    action [ :disable, :stop ]
end

execute "sudo rm -Rf #{node[:repository][:dir]}"




