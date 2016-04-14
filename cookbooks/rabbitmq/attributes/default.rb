default["packages"]["cache_dir"] = "/tmp"

default["packages"]["package_provider"] = platform_family?("debian") ? Chef::Provider::Package::Dpkg : Chef::Provider::Package::Rpm

default["rabbitmq"]["version"] = "3.6"

default["rabbitmq"]["packages"] = {
    "3.3" => {
        "debian" => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server_3.3.5-1_all.deb",
        "rhel"   => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server-3.3.5-1.noarch.rpm"},
    "3.4" => {
        "debian" => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server_3.4.2-1_all.deb",
        "rhel"   => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server-3.4.2-1.noarch.rpm"},
    "3.5" => {
        "debian" => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server_3.5.3-1_all.deb",
        "rhel"   => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server-3.5.3-1.noarch.rpm"},
    "3.6" => {
        "debian" => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server_3.6.1-1_all.deb",
        "rhel"   => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server-3.6.1-1.noarch.rpm"}}

default["esl_erlang"]["packages"] = {
    "debian" => "https://s3.amazonaws.com/scalr-labs/packages/esl-erlang_18.2-1~debian~wheezy_amd64.deb",
    "rhel6"  => "https://s3.amazonaws.com/scalr-labs/packages/erlang-18.2-1.el6.x86_64.rpm",
    "rhel7"  => "https://s3.amazonaws.com/scalr-labs/packages/erlang-18.2-1.el7.centos.x86_64.rpm"}

default["rabbitmq"]["package_url"] = node["rabbitmq"]["packages"].fetch(node["rabbitmq"]["version"]).fetch(node["platform_family"])
default["rabbitmq"]["package_path"] = File.join(node["packages"]["cache_dir"], node["rabbitmq"]["package_url"].split('/')[-1])

default["erlang"]["type"] = node["rabbitmq"]["version"] == "3.6" ? "custom" : "system"
default["erlang"]["type"] = "system" if platform?("ubuntu") and node["platform_version"].to_f >= 16.04


default["esl_erlang"]["package_url"] =
    case node["platform_family"]
    when "debian"
        node["esl_erlang"]["packages"].fetch(node["platform_family"])
    when "rhel"
        platform = platform?("amazon") ? "rhel6" : "#{node["platform_family"]}#{node["platform_version"].to_i}"
        node["esl_erlang"]["packages"].fetch(platform)
    end
default["esl_erlang"]["package_path"] = File.join(node["packages"]["cache_dir"], node["esl_erlang"]["package_url"].split('/')[-1])

default["erlang"]["package"] = platform_family?("debian") ? "erlang-nox" : "erlang"
