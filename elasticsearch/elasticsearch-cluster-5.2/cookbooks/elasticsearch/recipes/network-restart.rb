#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright 2017
#

service 'network-restart' do
  service_name 'network'
  action [ :restart ]
end
