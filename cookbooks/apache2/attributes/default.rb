name =
    case node["platform_family"]
    when "debian"
        "apache2"
    when "rhel"
        if platform?("amazon") && Chef::VersionConstraint.new(">=2014.09").include?(node["platform_version"])
            "httpd24"
        else
            "httpd"
        end
    end

default["apache2"]["package_name"] = default["apache2"]["service_name"] = name
