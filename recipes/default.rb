#-*- encoding : utf-8 -*-

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

  notifies :restart, 'service[elasticsearch]'
end

template "elasticsearch-env.sh" do
  path   "#{node.elasticsearch[:path][:conf]}/elasticsearch-env.sh"
  source "elasticsearch-env.sh.erb"
  owner node.elasticsearch[:user] and group node.elasticsearch[:user] and mode 0755
end


# Init File
template "elasticsearch.init" do
  path   "/etc/init.d/elasticsearch"
  source "elasticsearch.init.erb"
  owner 'root' and mode 0755
end

# Auto start
service "elasticsearch" do
  supports :status => true, :restart => true
  action [ :enable ]
end

# Monitoring by Monit
template "elasticsearch.monitrc" do
  path   "/etc/monit.d/elasticsearch.monitrc"
  source "elasticsearch.monitrc.erb"
  owner 'root' and mode 0755
end
