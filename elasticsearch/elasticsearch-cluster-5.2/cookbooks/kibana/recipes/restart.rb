#
# Cookbook:: kibana
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.


service 'kibana5' do
  service_name 'kibana'
  action [ :enable, :restart ]
end
