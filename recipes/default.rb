#
# Cookbook Name:: rsyslog-wrapper
# Recipe:: default
#
# Copyright 2014, Naoya Nakazawa
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
when 'rhel'
  if node['platform_version'].to_i == 5
    node.override['rsyslog']['preserve_fqdn'] = false
    node.override['rsyslog-wrapper']['syslogd_options'] = '-c 3'
  end
end

include_recipe 'rsyslog'


template '/etc/sysconfig/rsyslog' do
  source 'sysconfig.erb'
  action :create
  notifies :restart, "service[#{node['rsyslog']['service_name']}]"
  only_if { node['platform_family'] == 'rhel' }
end


begin
  r = resources("template[#{node['rsyslog']['config_prefix']}/rsyslog.conf]")
  r.cookbook 'rsyslog-wrapper'
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn "could not find template #{node['rsyslog']['config_prefix']}/rsyslog.conf} to override!"
end
