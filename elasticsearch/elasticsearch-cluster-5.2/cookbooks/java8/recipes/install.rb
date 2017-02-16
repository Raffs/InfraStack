#
# Cookbook Name:: java8
# Recipe:: default
#
# Copyright 2017
#

yum_package 'java8' do
  package_name 'java-1.8.0-openjdk'
  action :install
end
