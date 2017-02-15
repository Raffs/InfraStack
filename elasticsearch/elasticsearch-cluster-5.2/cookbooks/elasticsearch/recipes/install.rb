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
