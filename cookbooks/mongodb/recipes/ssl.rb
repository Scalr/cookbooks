case node[:platform_family]
# Debian like os
when "debian"
    # Install requirements
	execute "sudo apt-get update && sudo apt-get install git-core build-essential scons libssl-dev  libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev -y"

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
        sudo scons  debug=0 --release --64 --clean --cache-disable --no-glibc-check --ssl all
        sudo scons --ssl install
    EOH
end

# Change service state
service "mongodb" do
    service_name node[:service][:name]
    stop_command node[:service][:stop_command]
    action [ :stop, :disable ]
end

execute "sudo rm -Rf #{node[:repository][:dir]}"


#Add user
user "mongodb" do
    username node[:user][:name]
    gid node[:user][:gid]
    home node[:user][:home]
    shell node[:user][:shell]
    action :create
end

#Add group
group "mongodb" do
    append true
    group_name node[:group][:name]
    gid node[:group][:gid]
    members node[:group][:members]
    action :create
end



