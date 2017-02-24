#
# Cookbook:: logstash
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

template 'elasticsearh-config' do
  group                      'elasticsearch'
  mode                       '0660'
  owner                      'root'
  path                       '/etc/elasticsearch/elasticsearch.yml'
  source                     'elasticsearch.yml.erb'
  variables({
    :hostname => Chef::Config[:node_name]
  })
  action                     :create
end
