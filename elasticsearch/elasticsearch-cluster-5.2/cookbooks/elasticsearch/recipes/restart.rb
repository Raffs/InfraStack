#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright 2017
#

service 'elasticsearch7' do
  service_name 'elasticsearch'
  action [ :enable, :start ]
end
