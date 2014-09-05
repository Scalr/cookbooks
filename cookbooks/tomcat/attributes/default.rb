default["tomcat"]["version"] = "7"

if (platform?("ubuntu") && node["platform_version"].to_f < 12.04) ||
   (platform?("debian") && node["platform_version"].to_f < 7)
    default["tomcat"]["version"] = '6' 
end

tomcat = "tomcat#{node[:tomcat][:version]}"

case node["platform_family"]
when "debian"
    default["tomcat"]["packages"] = [tomcat, "#{tomcat}-admin"]

when "rhel"
    if node["tomcat"]["version"] == '7'
        tomcat = "tomcat"
        default["tomcat"]["from_epel"] = true
    end
    default["tomcat"]["packages"] = [tomcat, "#{tomcat}-admin-webapps"]
end

default["tomcat"]["service_name"] = tomcat 
