#
# Cookbook:: ELK5.2
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

rpm_package 'elasticsearch5.2' do
  source 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.2.0.rpm'
  action :install
end
