default["mongodb"]["service_name"] = "mongod"

# Latest minor version extracted from http://downloads-distro.mongodb.org/repo/
default["mongodb"]["full_versions"] = {"2.4" => "2.4.10", "2.6" => "2.6.4"}

# Default package for unversioned installation
default["mongodb"]["install_packages"] = ["mongodb-org"]

if node["mongodb"]["version"]
    # Different package names for different versions... 
    if node["mongodb"]["version"].to_f < 2.6
        # And different platfroms
        case node["platform_family"]
        when "debian"
            default["mongodb"]["package_names"] = %w{mongodb-10gen}
            default["mongodb"]["service_name"] = "mongodb"
        when "rhel"
            default["mongodb"]["package_names"] = %w{mongo-10gen mongo-10gen-server}
        end
    else
        default["mongodb"]["package_names"] = %w{mongodb-org mongodb-org-server mongodb-org-shell mongodb-org-mongos mongodb-org-tools}
    end

    version = node["mongodb"]["full_versions"][node["mongodb"]["version"]] 

    default["mongodb"]["install_packages"] = default["mongodb"]["package_names"].map do |pkg|
        case node["platform_family"]
        when "debian"
            pkg
        when "rhel"
            "#{pkg}-#{version}"
        end
    end
end


# MongoDB repo settings
default[:repository][:dir] = "/var/tmp/mongodb-src"
default[:repository][:revision] = "r2.6.1"
