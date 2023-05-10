#
# Cookbook:: checkmk
# Recipe:: agent-cmk
#
# Copyright:: 2019, Ed Overton, Apache 2.0

append_if_no_line node['cmka']['server_name'] do
  path '/etc/hosts'
  line "#{node['cmka']['server_ip']} #{node['cmka']['server_name']}"
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node['cmka']['agent_rpm']}" do
  source "http://#{node['cmka']['server_name']}:8080/#{node['cmka']['site_name']}/check_mk/agents/#{node['cmka']['agent_rpm']}"
  action :create
end

package 'agent-rpm' do
  source "#{Chef::Config[:file_cache_path]}/#{node['cmka']['agent_rpm']}"
  action :install
end

package %w(python3 python3-requests python3-urllib3 jq)

# Create host - requests
template '/usr/local/bin/add-checkmks.py' do
  source 'add-checkmks.py.erb'
  mode '0755'
  variables(
    cmkserver: node['cmka']['server_name'],
    apitoken: node['cmka']['secret'],
    host_ip: node['cmka']['host_ip'],
    host_name: node['fqdn']
  )
  sensitive true
end

# Discover host - curl
template '/usr/local/bin/discover-checkmks.sh' do
  source 'discover-checkmks.sh.erb'
  mode '0755'
  variables(
    cmkserver: node['cmka']['server_name'],
    apitoken: node['cmka']['secret'],
    host_name: node['fqdn']
  )
  sensitive true
end

# Activate changes - curl
template '/usr/local/bin/activate-checkmks.sh' do
  source 'activate-checkmks.sh.erb'
  mode '0755'
  variables(
    cmkserver: node['cmka']['server_name'],
    apitoken: node['cmka']['secret']
  )
  sensitive true
end

template '/usr/local/bin/register-checkmks.sh' do
  source 'register-checkmks.sh.erb'
  mode '0755'
  variables(
    cmkserver: node['cmka']['server_name'],
    cmksite: node['cmka']['site_name'],
    apitoken: node['cmka']['secret'],
    host_name: node['fqdn']
  )
  sensitive true
end

execute 'run_add-checkmks' do
  command '/usr/local/bin/add-checkmks.py'
  ignore_failure true
  action :nothing
end

execute 'run_discover-checkmks' do
  command '/usr/local/bin/discover-checkmks.py'
  ignore_failure true
  action :nothing
end

execute 'run_activate-checkmks' do
  command '/usr/local/bin/activate-checkmks.py'
  ignore_failure true
  action :nothing
end

execute 'run_register-checkmks' do
  command '/usr/local/bin/register-checkmks.sh'
  ignore_failure true
  action :nothing
end
