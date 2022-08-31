#
# Cookbook:: checkmk
# Recipe:: agent-cmk-snmp
#
# Copyright:: 2019, Ed Overton, Apache 2.0

package 'epel-release'

package %w(
  httpie
)

append_if_no_line node['cmk']['server_name'] do
  path '/etc/hosts'
  line "#{node['cmk']['server_ip']} #{node['cmk']['server_name']}"
end

# Create file from template
template '/tmp/add-checkmks-snmp.py' do
  source 'add-checkmks-snmp1.erb'
  mode '0500'
  sensitive false
  variables(
    cmkserver: node['cmk']['server_name'],
    apitoken: node['cmk']['api_token'],
    agenthostname: node['hostname'],
    agentip: node['cmk']['agent_ip']
  )
  # notifies :run, 'execute[run_add-checkmks-snmp]', :immediately
end

execute 'run_add-checkmks-snmp' do
  command '/tmp/add-checkmks-snmp.py'
  ignore_failure true
  action :nothing
end

# Create file from template
template '/tmp/discover-checkmks.sh' do
  source 'discover-checkmks.erb'
  mode '0500'
  sensitive false
  variables(
    cmkserver: node['cmk']['server_name'],
    apitoken: node['cmk']['api_token'],
    agenthostname: node['hostname']
  )
  # notifies :run, 'execute[run_discover-checkmks]', :immediately
end

# Create file from template
template '/tmp/discover-checkmks1.py' do
  source 'discover-checkmks1.erb'
  mode '0500'
  sensitive false
  variables(
    cmkserver: node['cmk']['server_name'],
    apitoken: node['cmk']['api_token'],
    agenthostname: node['hostname']
  )
  # notifies :run, 'execute[run_discover-checkmks]', :immediately
end

# Create file from template
template '/tmp/discover-checkmks2.py' do
  source 'discover-checkmks2.erb'
  mode '0500'
  sensitive false
  variables(
    cmkserver: node['cmk']['server_name'],
    apitoken: node['cmk']['api_token'],
    agenthostname: node['hostname']
  )
  # notifies :run, 'execute[run_discover-checkmks]', :immediately
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
  sensitive false
  variables(
    cmkserver: node['cmk']['server_name'],
    apitoken: node['cmk']['api_token'],
    sitename: node['cmk']['site_name']
  )
  # notifies :run, 'execute[run_activate-checkmks]', :immediately
end

execute 'run_activate-checkmks' do
  command '/tmp/activate-checkmks.py'
  ignore_failure true
  action :nothing
end
