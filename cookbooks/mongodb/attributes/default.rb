default["mongodb"]["service_name"] = "mongod"

# Latest minor version extracted from http://downloads-distro.mongodb.org/repo/
default["mongodb"]["full_versions"] = {"2.4" => {"debian" => "2.4.10", "rhel" => "2.4.10"}, "2.6" => {"debian" => "2.6.4", "rhel" => "2.6.4-1"}}

# Default package for unversioned installation
default["mongodb"]["packages"] = ["mongodb-org"]

if node["mongodb"]["version"]
    # Different package names for different versions... 
    if node["mongodb"]["version"].to_f < 2.6
        # And different platfroms
        case node["platform_family"]
        when "debian"
            default["mongodb"]["packages"] = %w{mongodb-10gen}
            default["mongodb"]["service_name"] = "mongodb"
        when "rhel"
            default["mongodb"]["packages"] = %w{mongo-10gen mongo-10gen-server}
        end
    else
        default["mongodb"]["packages"] = %w{mongodb-org mongodb-org-server mongodb-org-shell mongodb-org-mongos mongodb-org-tools}
    end

    default["mongodb"]["full_version"] = node["mongodb"]["full_versions"].fetch(node["mongodb"]["version"]).fetch(node["platform_family"])
    raise "Unsupported version" if not node["mongodb"]["full_version"]
end


# MongoDB repo settings
default[:repository][:dir] = "/var/tmp/mongodb-src"
default[:repository][:revision] = "r2.6.1"
