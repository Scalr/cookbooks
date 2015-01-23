default["percona"]["version"] = 
    case node["platform_family"]
    when "debian"
        if node["platform"] == "debian"
            '5.5'
        elsif node["lsb"]["release"].to_f >= 14.04
            '5.6'
        elsif node["lsb"]["release"].to_f >= 12.04
            '5.5'
        else
            '5.1'
        end
    when "rhel"
        if ["centos", "redhat"].include?(node["platform"]) && node["platform_version"].to_i == 7
            '56'
        elsif node["platform_version"].to_f >= 6.0
            '55'
        else
            '51'
        end
    end
