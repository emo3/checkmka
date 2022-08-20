default['cmk'].tap do |cmk|
  cmk['cmk_release'] = '2.1.0p9'
  cmk['media_url'] = "https://download.checkmk.com/checkmk/#{node['cmk']['cmk_release']}"
  cmk['agent_rpm'] = "check-mk-agent-#{cmk['cmk_release']}-1.noarch.rpm"
  cmk['server_ip'] = node['CMK_IP'] || node['ipaddress']
  cmk['agent_ip'] = node['CMA_IP'] || node['ipaddress']
  cmk['site_name'] = 'cmk'
  cmk['server_name'] = 'checkmks'
  cmk['api_url'] = "http://#{cmk['server_name']}/#{cmk['site_name']}/check_mk/webapi.py"
  cmk['api_token'] = node['CMK_TOKEN'] || '2a6c4125-af68-48f4-b139-4a06e800a4d4'
  cmk['api_user'] = 'automation'
  cmk['api_login'] = "_username=#{cmk['api_user']}&_secret=#{cmk['api_token']}"
end
