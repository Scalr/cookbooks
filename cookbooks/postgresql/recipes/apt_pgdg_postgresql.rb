include_recipe 'apt'

apt_repository 'apt.postgresql.org' do
  uri 'http://apt.postgresql.org/pub/repos/apt'
  distribution "#{node['postgresql']['pgdg']['release_apt_codename']}-pgdg"
  components ['main', node['postgresql']['version']]
  key 'http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc'
  action :add
end
