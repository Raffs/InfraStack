#
# Cookbook:: ELK5.2
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

template 'java-config' do
  group                      'elasticsearch'
  mode                       '0660'
  owner                      'root'
  path                       '/etc/elasticsearch/jvm.options'
  source                     'jvm.options.erb'
  action                     :create
end
