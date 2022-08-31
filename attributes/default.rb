default['cmk']['cmk_release'] = '2.0.0p27'
default['cmk']['media_url'] = "https://download.checkmk.com/checkmk/#{node['cmk']['cmk_release']}"
default['cmk']['agent_rpm'] = "check-mk-agent-#{node['cmk']['cmk_release']}-1.noarch.rpm"
default['cmk']['site_name'] = 'cmk'
default['cmk']['server_name'] = 'checkmks'
default['cmk']['api_url'] = "http://#{node['cmk']['server_name']}/#{node['cmk']['site_name']}/check_mk/webapi.py"
default['cmk']['api_user'] = 'automation'
default['cmk']['api_login'] = "_username=#{node['cmk']['api_user']}&_secret=#{node['cmk']['api_token']}"
