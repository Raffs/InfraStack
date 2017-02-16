#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright 2017
#

service 'elasticsearch5.2' do
  service_name 'elasticsearch'
  action [ :enable, :restart ]
end
