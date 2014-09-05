case node["platform_family"]
when "debian"
    package "logrotate"
    package "erlang-nox"

when "rhel"
    raise if node[:platform_version].to_f < 6

    include_recipe "epel"
    package "erlang"
end

remote_file node["rabbitmq"]["package_path"] do
    source node["rabbitmq"]["package_url"]
end

package "rabbitmq" do
    source node["rabbitmq"]["package_path"]
    provider node["rabbitmq"]["package_provider"]
    action :install
end


service "rabbitmq-server" do
    action [:disable, :stop]
end
