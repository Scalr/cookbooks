default["mariadb"]["version"] = "5.5"

if platform_family?("rhel")
    arch = node[:kernel][:machine] =~ /x86_64/ ? "amd64" : "x86"
    default["mariadb"]["yum_repo_url"] =
        if platform?("amazon")
            "http://yum.mariadb.org/#{node[:mariadb][:version]}/rhel6-#{arch}"
        else
            "http://yum.mariadb.org/#{node[:mariadb][:version]}/#{node[:platform]}#{node[:platform_version].to_i}-#{arch}"
        end
end
