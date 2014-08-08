default['postgresql']['version'] = '9.3'

case node['platform']
when "redhat", "centos"
    default['postgresql']['dir'] = "/var/lib/pgsql/#{node['postgresql']['version']}/data"
    default['postgresql']['service_name'] = "postgresql-#{node['postgresql']['version']}"
    default['postgresql']['packages'] = ["postgresql#{node['postgresql']['version'].split('.').join}",
                                                   "postgresql#{node['postgresql']['version'].split('.').join}-server",
                                                   "postgresql#{node['postgresql']['version'].split('.').join}-devel"]
when "debian", "ubuntu"
     default['postgresql']['dir'] = "/etc/postgresql/#{node['postgresql']['version']}/main"
     default['postgresql']['service_name'] = "postgresql"
     default['postgresql']['packages'] = ["postgresql-#{node['postgresql']['version']}"] 
     default['postgresql']['pgdg']['release_apt_codename'] = node['lsb']['codename']
end


# The PostgreSQL RPM Building Project built repository RPMs for easy
# access to the PGDG yum repositories. Links to RPMs for installation
# on the supported version/platform combinations are listed at
# http://yum.postgresql.org/repopackages.php, and the links for
# PostgreSQL 8.4, 9.0, 9.1, 9.2 and 9.3 are captured below.
#
# The correct RPM for installing /etc/yum.repos.d is based on:
# * the attribute configuring the desired Postgres Software:
#   node['postgresql']['version']        e.g., "9.1"
# * the chef ohai description of the target Operating System:
#   node['platform']                     e.g., "centos"
#   node['platform_version']             e.g., "5.7", truncated as "5"
#   node['kernel']['machine']            e.g., "i386" or "x86_64"
default['postgresql']['pgdg']['repo_rpm_url'] = {
  "9.3" => {
    "centos" => {
      "6" => {
        "i386" => "http://yum.postgresql.org/9.3/redhat/rhel-6-i386/pgdg-centos93-9.3-1.noarch.rpm",
        "x86_64" => "http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm"
      },
      "5" => {
        "i386" => "http://yum.postgresql.org/9.3/redhat/rhel-5-i386/pgdg-centos93-9.3-1.noarch.rpm",
        "x86_64" => "http://yum.postgresql.org/9.3/redhat/rhel-5-x86_64/pgdg-centos93-9.3-1.noarch.rpm"
      }
    },
    "redhat" => {
      "6" => {
        "i386" => "http://yum.postgresql.org/9.3/redhat/rhel-6-i386/pgdg-redhat93-9.3-1.noarch.rpm",
        "x86_64" => "http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-redhat93-9.3-1.noarch.rpm"
      },
      "5" => {
        "i386" => "http://yum.postgresql.org/9.3/redhat/rhel-5-i386/pgdg-redhat93-9.3-1.noarch.rpm",
        "x86_64" => "http://yum.postgresql.org/9.3/redhat/rhel-5-x86_64/pgdg-redhat93-9.3-1.noarch.rpm"
      }
    }
  },
  "9.2" => {
    "centos" => {
      "6" => {
        "i386" => "http://yum.postgresql.org/9.2/redhat/rhel-6-i386/pgdg-centos92-9.2-6.noarch.rpm",
        "x86_64" => "http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm"
      },
      "5" => {
        "i386" => "http://yum.postgresql.org/9.2/redhat/rhel-5-i386/pgdg-centos92-9.2-6.noarch.rpm",
        "x86_64" => "http://yum.postgresql.org/9.2/redhat/rhel-5-x86_64/pgdg-centos92-9.2-6.noarch.rpm"
      }
    },
    "redhat" => {
      "6" => {
        "i386" => "http://yum.postgresql.org/9.2/redhat/rhel-6-i386/pgdg-redhat92-9.2-7.noarch.rpm",
        "x86_64" => "http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-redhat92-9.2-7.noarch.rpm"
      },
      "5" => {
        "i386" => "http://yum.postgresql.org/9.2/redhat/rhel-5-i386/pgdg-redhat92-9.2-7.noarch.rpm",
        "x86_64" => "http://yum.postgresql.org/9.2/redhat/rhel-5-x86_64/pgdg-redhat92-9.2-7.noarch.rpm"
      }
    }
  },
  "9.1" => {
    "centos" => {
      "6" => {
        "i386" => "http://yum.postgresql.org/9.1/redhat/rhel-6-i386/pgdg-centos91-9.1-4.noarch.rpm",
        "x86_64" => "http://yum.postgresql.org/9.1/redhat/rhel-5-x86_64/pgdg-centos91-9.1-4.noarch.rpm"
      },
      "5" => {
        "i386" => "http://yum.postgresql.org/9.1/redhat/rhel-5-i386/pgdg-centos91-9.1-4.noarch.rpm",
        "x86_64" => "http://yum.postgresql.org/9.1/redhat/rhel-5-x86_64/pgdg-centos91-9.1-4.noarch.rpm"
      },
      "4" => {
        "i386" => "http://yum.postgresql.org/9.1/redhat/rhel-4-i386/pgdg-centos91-9.1-4.noarch.rpm",
        "x86_64" => "http://yum.postgresql.org/9.1/redhat/rhel-4-x86_64/pgdg-centos91-9.1-4.noarch.rpm"
      }
    },
    "redhat" => {
      "6" => {
        "i386" => "http://yum.postgresql.org/9.1/redhat/rhel-6-i386/pgdg-redhat91-9.1-5.noarch.rpm",
        "x86_64" => "http://yum.postgresql.org/9.1/redhat/rhel-6-x86_64/pgdg-redhat91-9.1-5.noarch.rpm"
      },
      "5" => {
        "i386" => "http://yum.postgresql.org/9.1/redhat/rhel-5-i386/pgdg-redhat91-9.1-5.noarch.rpm",
        "x86_64" => "http://yum.postgresql.org/9.1/redhat/rhel-5-x86_64/pgdg-redhat91-9.1-5.noarch.rpm"
      },
      "4" => {
        "i386" => "http://yum.postgresql.org/9.1/redhat/rhel-4-i386/pgdg-redhat-9.1-4.noarch.rpm",
        "x86_64" => "http://yum.postgresql.org/9.1/redhat/rhel-4-x86_64/pgdg-redhat-9.1-4.noarch.rpm"
      }
    }
  }
};

