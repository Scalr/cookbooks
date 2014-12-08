default["passenger"]["version"] = '3.0.9'
default["passenger"]["root_path"]        = "#{node["languages"]["ruby"]["gems_dir"]}/gems/passenger-#{passenger["version"]}"
default["passenger"]["module_path"]      = "#{passenger["root_path"]}/ext/apache2/mod_passenger.so"
default["passenger"]["apache_conf_path"] = '/etc/httpd/conf.d/passenger.conf'
