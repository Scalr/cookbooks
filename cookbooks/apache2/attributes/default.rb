name =
    case node["platform_family"]
    when "debian"
        "apache2"
    when "rhel"
        if platform?("amazon") && node["platform_version"] == "2014.09"
            "httpd24"
        else
            "httpd"
        end
    end

default["apache2"]["package_name"] = default["apache2"]["service_name"] = name
