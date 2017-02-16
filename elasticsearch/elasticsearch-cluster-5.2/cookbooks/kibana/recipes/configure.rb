#
# Cookbook:: kibana
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

template 'kibana-config' do
  group                      'kibana'
  mode                       '0660'
  owner                      'root'
  path                       '/etc/kibana/kibana.yml'
  source                     'kibana.yml.erb'
  action                     :create
end
