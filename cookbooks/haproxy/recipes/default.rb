if node['platform'] == 'debian' and node['lsb']['codename'] == 'wheezy'
    file "/etc/apt/sources.list.d/wheezy-backports.list" do
        content "deb http://ftp.debian.org/debian/ wheezy-backports main"
    end
    execute "apt-get update"
end

package "haproxy"
