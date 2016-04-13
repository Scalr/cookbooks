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

default["apache2"]["mod_php"]["package_list"] =
    case node["platform_family"]
    when "debian"
        version = '5'
        version = '' if platform?("ubuntu") and node["platform_version"].to_f >= 16.04
        packages = ["libapache2-mod-php#{version}", "php#{version}-cli", "php#{version}-mysql"]
        packages << "php5-suhosin" if platform?("ubuntu") and node["platform_version"].to_f < 13.10

        packages
    when "rhel"
        php = if platform?("centos") and node["platform_version"].to_f < 6.0
                  "php53"
              elsif platform?("amazon") && Chef::VersionConstraint.new(">=2014.09").include?(node["platform_version"])
                  "php54"
              else
                  "php"
              end

        [php, "#{php}-mysql"]
    end
