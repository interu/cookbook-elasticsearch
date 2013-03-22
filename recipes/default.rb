#-*- encoding : utf-8 -*-
elasticsearch = "elasticsearch-#{node.elasticsearch[:version]}"
include_recipe "elasticsearch::packages"

# Create user and group
group node.elasticsearch[:user] do
  action :create
end

user node.elasticsearch[:user] do
  comment "ElasticSearch User"
  home    "#{node.elasticsearch[:dir]}/elasticsearch"
  shell   "/bin/bash"
  gid     node.elasticsearch[:user]
  supports :manage_home => false
  action  :create
end

# Install ElasticSearch
script "install_elasticsearch" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
    wget "#{node.elasticsearch[:download_url]}"
    tar xvzf #{node.elasticsearch[:filename]} -C #{node.elasticsearch[:dir]}
    ln -s #{node.elasticsearch[:home_dir]}-#{node.elasticsearch[:version]} #{node.elasticsearch[:home_dir]}
  EOH
end

# Install Kuromoji plugin
script "install_plugins" do
  interpreter "bash"
  user "root"
  cwd "#{node.elasticsearch[:home_dir]}"
  code <<-EOH
    bin/plugin -install elasticsearch/elasticsearch-analysis-kuromoji/1.1.0
  EOH
end

# Create Directories
[ node.elasticsearch[:path][:conf], node.elasticsearch[:path][:data], node.elasticsearch[:path][:logs], node.elasticsearch[:path][:pids] ].each do |path|
  directory path do
    owner node.elasticsearch[:user] and group node.elasticsearch[:user] and mode 0755
    recursive true
    action :create
  end
end

# Configration
template "elasticsearch.yml" do
  path   "#{node.elasticsearch[:path][:conf]}/elasticsearch.yml"
  source "elasticsearch.yml.erb"
  owner node.elasticsearch[:user] and group node.elasticsearch[:user] and mode 0755

  #notifies :restart, 'service[elasticsearch]'
end

# Monitoring by Monit

# Init File
#template "/etc/init.d/elasticsearch" do
#  source "elasticsearch.init.erb"
#  owner 'root' and mode 0755
#end
