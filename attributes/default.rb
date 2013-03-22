# #-*- encoding : utf-8 -*-
# === VERSION AND LOCATION
#
default.elasticsearch[:version]       = "0.20.5"
default.elasticsearch[:host]          = "http://download.elasticsearch.org"
default.elasticsearch[:repository]    = "elasticsearch/elasticsearch"
default.elasticsearch[:filename]      = "elasticsearch-#{node.elasticsearch[:version]}.tar.gz"
default.elasticsearch[:download_url]  = [node.elasticsearch[:host], node.elasticsearch[:repository], node.elasticsearch[:filename]].join('/')

# === USER & PATHS
#
default.elasticsearch[:dir]       = "/usr/local"
default.elasticsearch[:user]      = "elasticsearch"
default.elasticsearch[:home_dir]  = [node.elasticsearch[:dir], node.elasticsearch[:user]].join('/')

default.elasticsearch[:path][:conf] = [node.elasticsearch[:home_dir], "config"].join('/')
default.elasticsearch[:path][:data] = [node.elasticsearch[:home_dir], "data"].join('/')
default.elasticsearch[:path][:logs] = [node.elasticsearch[:home_dir], "logs"].join('/')
default.elasticsearch[:path][:pids]  = '/var/run/elasticsearch'
default.elasticsearch[:pid_file]  = [node.elasticsearch[:path][:pids], "elasticsearch.pid"].join('/')
