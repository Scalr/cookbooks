if node["rabbitmq"]["version"] == "3.6"
    remote_file node["esl_erlang"]["package_path"] do
        source node["esl_erlang"]["package_url"]
    end
    package "custom_erlang" do
        source node["esl_erlang"]["package_path"]
        provider node["packages"]["package_provider"]
        case node["platform_family"]
        when "debian"
            ignore_failure true
        end
    end
else
    package "custom_erlang" do
        package_name node["erlang"]["package"]
    end
end

case node["platform_family"]
when "debian"
    execute "apt-get update"
    package "logrotate"

when "rhel"
    raise if node["platform_version"].to_f < 6

    include_recipe "epel"
end

package "custom_erlang" do
    action :install
end

execute "install-dependencies" do
    case node["platform_family"]
    when "debian"
        command "apt-get -yf install"
        action :run
        only_if { File.exists?(node["esl_erlang"]["package_path"])}
    end
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
