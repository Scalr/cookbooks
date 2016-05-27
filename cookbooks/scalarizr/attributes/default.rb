default["scalarizr"]["behaviour"] = ["base"]
default["scalarizr"]["platform"]  = "ec2"
default["scalarizr"]["branch"] = "latest"


repo_name = case node['scalarizr']['branch']
            when "stable"
                "stable"
            when "latest", "" # Empty branch string also means we want latest
                "latest"
            else
                "drone"
            end
branch = (repo_name == 'drone') ? node['scalarizr']['branch'] : ''

default['scalarizr']['script_url'] =
    "https://my.scalr.net/public/linux/#{repo_name}/#{node['scalarizr']['platform']}/#{branch}/install_scalarizr.sh"

default['scalarizr']['script_path'] = "#{Chef::Config['file_cache_path']}/#{File.basename(node['scalarizr']['script_url'])}"
