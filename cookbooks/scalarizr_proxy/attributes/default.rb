default['scalarizr_proxy']['scalr_addr'] = "http://127.0.0.1"
default['scalarizr_proxy']['whitelist'] = []
default['scalarizr_proxy']['nginx_user'] = value_for_platform_family(
	'rhel' => 'nginx',
	'default' => 'www-data'
)
