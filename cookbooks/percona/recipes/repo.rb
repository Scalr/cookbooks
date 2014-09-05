# Installs percona repo

case node["platform_family"]
when "debian"
    include_recipe "apt"
    apt_repository "percona" do
        uri          "http://repo.percona.com/apt"
        distribution node["lsb"]["codename"]
        components   ["main"]
        #keyserver    "keys.gnupg.net"
        keyserver    "keyserver.ubuntu.com"
        key          "CD2EFD2A"
        action       :add
    end
    
when "rhel"
    include_recipe "yum"
    yum_repository "percona" do
        description "Percona YUM repo"
        baseurl     "http://repo.percona.com/centos/#{platform?(:amazon) ? 6 : '$releasever'}/os/$basearch/"
        gpgkey      "http://www.percona.com/downloads/RPM-GPG-KEY-percona"
        gpgcheck    true
        sslverify   true
        action      :create 
    end
end
