default['cmka']['cmk_release'] = '2.1.0p26'
default['cmka']['media_url'] = "https://download.checkmk.com/checkmk/#{node['cmka']['cmk_release']}"
default['cmka']['agent_rpm'] = "check-mk-agent-#{node['cmka']['cmk_release']}-1.noarch.rpm"
default['cmka']['site_name'] = 'cmk'
default['cmka']['server_name'] = 'checkmks'
default['cmka']['server_ip'] = '10.1.1.20'
default['cmka']['host_ip'] = '10.1.1.21'
default['cmka']['secret'] = '390facd5-4d84-4f6b-8df6-c647ef1e9dde'
