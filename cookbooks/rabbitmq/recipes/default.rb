case node["platform_family"]
when "debian"
    execute "apt-get update"
    package "logrotate"
when "rhel"
    raise if node["platform_version"].to_f < 6
    include_recipe "epel"
end

remote_file node["esl_erlang"]["package_path"] do
    source node["esl_erlang"]["package_url"]
    only_if { node["erlang"]["type"] == "custom" }
end

package "erlang" do
    case node["erlang"]["type"]
    when "system"
        package_name node["erlang"]["package"]
    when "custom"
        source node["esl_erlang"]["package_path"]
        provider node["packages"]["package_provider"]
        ignore_failure  platform_family?("debian") ? true : false
    end
    action :install
end

execute "install-dependencies" do
    command "apt-get -yf install"
    action :run
    only_if { node["erlang"]["type"] == "custom" and platform_family?("debian") }
end

remote_file node["rabbitmq"]["package_path"] do
    source node["rabbitmq"]["package_url"]
end

package "rabbitmq" do
    source node["rabbitmq"]["package_path"]
    provider node["packages"]["package_provider"]
    action :install
end

service "rabbitmq-server" do
    action [:disable, :stop]
end
