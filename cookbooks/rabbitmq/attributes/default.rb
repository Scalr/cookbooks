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
        "debian" => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server_3.6.0-1_all.deb",
        "rhel"   => "https://s3.amazonaws.com/scalr-labs/packages/rabbitmq-server-3.6.0-1.noarch.rpm"}}

default["esl_erlang"]["packages"] = {
    "debian" => "https://s3.amazonaws.com/scalr-labs/packages/esl-erlang_18.2-1~debian~wheezy_amd64.deb",
    "rhel" => {
        6 => "https://s3.amazonaws.com/scalr-labs/packages/erlang-18.2-1.el6.x86_64.rpm",
        7 => "https://s3.amazonaws.com/scalr-labs/packages/erlang-18.2-1.el7.centos.x86_64.rpm"}}

default["packages"]["cache_dir"] = "/tmp"

default["rabbitmq"]["package_url"] = node["rabbitmq"]["packages"].fetch(node["rabbitmq"]["version"]).fetch(node["platform_family"])
default["rabbitmq"]["package_path"] = File.join(node["packages"]["cache_dir"], node["rabbitmq"]["package_url"].split('/')[-1])

esl_erlang_packages = node["esl_erlang"]["packages"].fetch(node["platform_family"])
default["esl_erlang"]["package_url"] =
    if node["platform_family"] == "debian"
        esl_erlang_packages
    elsif node["platform"] == "amazon"
        esl_erlang_packages[6]
    else
        esl_erlang_packages.fetch(node["platform_version"].to_i)
    end
default["esl_erlang"]["package_path"] = File.join(node["packages"]["cache_dir"], node["esl_erlang"]["package_url"].split('/')[-1])
default["erlang"]["packages"] = {
    "debian" => "erlang-nox",
    "rhel" => "erlang"}
default["erlang"]["package"] = node["erlang"]["packages"].fetch(node["platform_family"])

default["packages"]["package_provider"] =
    case node["platform_family"]
    when "debian"
        Chef::Provider::Package::Dpkg
    when "rhel"
        Chef::Provider::Package::Rpm
    end
