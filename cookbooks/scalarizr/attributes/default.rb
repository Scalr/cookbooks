default["scalarizr"]["behaviour"] = ["base"]
default["scalarizr"]["platform"]  = "ec2"
default["scalarizr"]["branch"] = "latest"


case node['scalarizr']['branch']
when "stable"
    default['scalarizr']['repo_name'] = "scalr"
    case node["platform_family"]
    when "rhel"
            default['scalarizr']['baseurl'] = "http://rpm-delayed.scalr.net/rpm/rhel/$releasever/$basearch/"
    when "debian"
            default['scalarizr']['uri'] = "http://apt-delayed.scalr.net/debian/"
            default['scalarizr']['distribution'] = "scalr/"
    end
when "latest", "" # Empty branch string also means we want latest
    default['scalarizr']['repo_name'] = "scalr"
    case node["platform_family"]
    when "rhel"
            default['scalarizr']['baseurl'] = "http://repo.scalr.net/rpm/latest/rhel/$releasever/$basearch/"
    when "debian"
            default['scalarizr']['uri'] = "http://repo.scalr.net/apt-plain"
            default['scalarizr']['distribution'] = "latest/"
    end
else
    default['scalarizr']['repo_name'] = "scalr-devel"
    branch = (node['scalarizr']['branch'] == 'candidate')? 'master' : node['scalarizr']['branch']
    case node["platform_family"]
    when "rhel"
            default['scalarizr']['baseurl'] = "http://stridercd.scalr-labs.com/scalarizr/rpm/develop/#{branch}/rhel/$releasever/$basearch/"
    when "debian"
            default['scalarizr']['uri'] = "http://stridercd.scalr-labs.com/scalarizr/apt-plain/develop/"
            default['scalarizr']['distribution'] = "#{branch}/"
    end
end
