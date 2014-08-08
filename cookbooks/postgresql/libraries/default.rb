module Scalr
  module PostgresqlHelpers
    # Borrowed from https://github.com/hw-cookbooks/postgresql/
    def pgdgrepo_rpm_info
      repo_rpm_url = node['postgresql']['pgdg']['repo_rpm_url'].
        fetch(node['postgresql']['version']).            # e.g., fetch for "9.1"
        fetch(node['platform']).                         # e.g., fetch for "centos"
        fetch(node['platform_version'].to_f.to_i.to_s).  # e.g., fetch for "5" (truncated "5.7")
        fetch(node['kernel']['machine'])                 # e.g., fetch for "i386" or "x86_64"

      # Extract the filename portion from the URL for the PGDG repository RPM.
      # E.g., repo_rpm_filename = "pgdg-centos92-9.2-6.noarch.rpm"
      repo_rpm_filename = File.basename(repo_rpm_url)

      # Extract the package name from the URL for the PGDG repository RPM.
      # E.g., repo_rpm_package = "pgdg-centos92"
      repo_rpm_package = repo_rpm_filename.split(/-/,3)[0..1].join('-')

      return [ repo_rpm_url, repo_rpm_filename, repo_rpm_package ]
    end
  end
end
