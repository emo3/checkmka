#
# Cookbook:: checkmk
# Recipe:: agent-cmk
#
# Copyright:: 2019, Ed Overton, Apache 2.0

log node['cmk']['api_token']
log node['cmk']['agent_ip']
log node['cmk']['server_ip']

package 'epel-release'

package %w(
  httpie
  xinetd
)

service 'xinetd' do
  supports status: true, restart: true, reload: true
  action [ :enable, :start ]
end

append_if_no_line 'hosts_allow' do
  path '/etc/hosts.allow'
  line "check_mk_agent : #{node['cmk']['server_ip']}"
  notifies :reload, 'service[xinetd]', :immediately
end

template '/etc/xinetd.d/check_mk' do
  source 'check-mk-agent'
  variables(
    ip_mk_server: node['cmk']['server_ip']
  )
  mode '0644'
  action :create
  notifies :reload, 'service[xinetd]', :immediately
end

append_if_no_line node['cmk']['server_name'] do
  path '/etc/hosts'
  line "#{node['cmk']['server_ip']} #{node['cmk']['server_name']}"
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node['cmk']['agent_rpm']}" do
  source "http://#{node['cmk']['server_name']}/#{node['cmk']['site_name']}/check_mk/agents/#{node['cmk']['agent_rpm']}"
  action :create
end

package 'agent-rpm' do
  source "#{Chef::Config[:file_cache_path]}/#{node['cmk']['agent_rpm']}"
  action :install
end

# Create file from template
template '/tmp/add-checkmks.py' do
  source 'add-checkmks1.erb'
  mode '0500'
  sensitive true
  variables(
    cmkserver: node['cmk']['server_name'],
    apitoken: node['cmk']['api_token'],
    agenthostname: node['hostname'],
    agentip: node['cmk']['agent_ip']
  )
  notifies :run, 'execute[run_add-checkmks]', :immediately
end

execute 'run_add-checkmks' do
  command '/tmp/add-checkmks.py'
  ignore_failure true
  action :nothing
end

# Create file from template
template '/tmp/discover-checkmks.py' do
  source 'discover-checkmks1.erb'
  mode '0500'
  sensitive true
  variables(
    cmkserver: node['cmk']['server_name'],
    apitoken: node['cmk']['api_token'],
    agenthostname: node['hostname']
  )
  notifies :run, 'execute[run_discover-checkmks]', :immediately
end

execute 'run_discover-checkmks' do
  command '/tmp/discover-checkmks.py'
  ignore_failure true
  action :nothing
end

# Create file from template
template '/tmp/activate-checkmks.py' do
  source 'activate-checkmks1.erb'
  mode '0500'
  sensitive true
  variables(
    cmkserver: node['cmk']['server_name'],
    apitoken: node['cmk']['api_token'],
    sitename: node['cmk']['site_name']
  )
  notifies :run, 'execute[run_activate-checkmks]', :immediately
end

execute 'run_activate-checkmks' do
  command '/tmp/activate-checkmks.py'
  ignore_failure true
  action :nothing
end
