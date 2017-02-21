#
# Cookbook:: logstash
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

rpm_package 'logstash' do
  source 'https://artifacts.elastic.co/downloads/logstash/logstash-5.2.1.rpm'
  action :install
end
