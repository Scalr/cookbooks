include_recipe "apt" if platform_family?("debian")
include_recipe "ntp"
  
if node["platform"] == "oracle"
  platform_version = node["platform_version"].to_i
  tag = node["platform_version"].to_i == 6 ? "ol" : "el"
  
  remote_file "/etc/yum.repos.d/public-yum-#{tag}#{platform_version}.repo" do
    source "http://public-yum.oracle.com/public-yum-#{tag}#{platform_version}.repo"
    mode "0644"
  end
end
