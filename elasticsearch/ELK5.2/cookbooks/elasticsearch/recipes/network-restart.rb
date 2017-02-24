#
# Cookbook Name:: elasticsearch
# Recipe:: network-restart
#
# Copyright:: 2017, The Authors, All Rights Reserved.

service 'network-restart' do
  service_name 'network'
  action [ :restart ]
end
