#
# Cookbook Name:: zabbix-agent
# Attribute:: default
#

case platform
when "debian", "ubuntu"
  set_unless['zabbix']['service'] = "zabbix-agent"
  default['zabbix']['package'] = "zabbix-agent"
  default['zabbix']['agent_conf'] = "/etc/zabbix/zabbix_agentd.conf"
end

default['zabbix']['agent_log_dir'] = "/var/log/zabbix-agent"
default['zabbix']['agent_pid_dir'] = "/var/run/zabbix"

default['zabbix']['server_name']   = "zabbix.example.com"
default['zabbix']['fqdn']          = node['fqdn']
default['zabbix']['active_check']  = false
default['zabbix']['agent_debuglevel'] = '3'
