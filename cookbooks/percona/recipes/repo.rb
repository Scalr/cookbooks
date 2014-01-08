# Installs percona repo

case node[:platform]
when "ubuntu","debian","gcel"
	execute "request percona key" do
	  command "apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A"
	  not_if "apt-key list | grep CD2EFD2A"
	end

	execute "apt-get update" do
	  action :nothing
	end

	template "/etc/apt/sources.list.d/percona.list" do
  		source "percona.list.erb"
  		mode "0644"
  		if node[:platform] == "gcel" or node[:lsb][:codename].start_with?("gcel")
  			variables( :codename => "precise")
  		else
  			variables( :codename => node[:lsb][:codename])
  		end

		notifies :run, resources("execute[apt-get update]"), :immediately
	end
when "redhat","centos","oracle","amazon"
	arch = node[:kernel][:machine]  =~ /x86_64/ ? "x86_64" : "i386"
	yum_package "gpg"
	execute "rpm -Uvh --replacepkgs http://www.percona.com/downloads/percona-release/percona-release-0.0-1.#{arch}.rpm"
end