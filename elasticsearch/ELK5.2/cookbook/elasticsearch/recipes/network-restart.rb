#
# Cookbook:: ELK5.2
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

service 'network-restart' do
  service_name 'network'
  action [ :restart ]
end
