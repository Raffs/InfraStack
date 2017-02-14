#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright 2017
#

rpm_package 'elasticsearch7' do
  source 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.2.0.rpm'
  action :install
end

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

service 'elasticsearch7' do
  service_name 'elasticsearch'
  action [ :enable, :start ]
end
