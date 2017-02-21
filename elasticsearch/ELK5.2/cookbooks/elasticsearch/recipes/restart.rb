#
# Cookbook Name:: elasticsearch
# Recipe:: restart
#
# Copyright:: 2017, The Authors, All Rights Reserved.

service 'elasticsearch5.2' do
  service_name 'elasticsearch'
  action [ :enable, :restart ]
end
