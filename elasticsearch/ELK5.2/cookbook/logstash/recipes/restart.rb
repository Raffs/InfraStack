#
# Cookbook:: logstash
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

service 'logstash' do
  service_name 'logstash'
  action [ :enable, :restart ]
end
