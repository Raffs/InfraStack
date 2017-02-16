#
# Cookbook:: kibana
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.


rpm_package 'kibana5.2' do
  source 'https://artifacts.elastic.co/downloads/kibana/kibana-5.2.1-x86_64.rpm'
  action :install
end
