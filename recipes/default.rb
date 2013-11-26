#
# Cookbook Name:: zabbix-agent
# Recipe:: default
#

package node['zabbix']['package'] do
  action :upgrade
end

template node['zabbix']['agent_conf'] do
  source   "zabbix_agentd.conf.erb"
  owner    "root"
  group    "root"
  mode     "0644"
  notifies :restart, "service[#{node['zabbix']['service']}]", :delayed
  variables(
    :logfile => "#{node['zabbix']['agent_log_dir']}/zabbix_agentd.log",
    :pidfile => "#{node['zabbix']['agent_pid_dir']}/zabbix_agentd.pid",
    :debuglevel => node['zabbix']['agent_debuglevel'],
    :server_name => node['zabbix']['server_name'],
    :server_hostname => node['zabbix']['fqdn'],
    :active_check => node['zabbix']['active_check'],
    :host_metadata => node['zabbix']['host_metadata'],
    :include_dir => "/etc/zabbix/agent-conf.d",
    :listen => node['zabbix']['listen']
  )
end

directory "/etc/zabbix/agent-conf.d" do
  owner "root"
  group "root"
  mode 0755
  recursive true
end

%w{log pid}.each do |i|
  directory node['zabbix']["agent_#{i}_dir"] do
    owner "zabbix"
    group "zabbix"
    mode 0755
    recursive true
  end
end

service node['zabbix']['service'] do
  pattern  "zabbix_agentd"
  supports [ :restart => true ]
  action   [ :enable, :start ]
end

file "/etc/zabbix/agent-conf.d/iostat.conf" do
  content %Q{UserParameter=dev.iostat[*],/usr/bin/sudo /usr/bin/iostat -x | /usr/bin/awk '/^$1 /{print $$$2}'}
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[#{node['zabbix']['service']}]", :delayed
end

begin
  sudo "zabbix-iostat" do
    user "zabbix"
    commands ['/usr/bin/iostat -x']
    nopasswd true
  end
rescue NameError => e
  Chef::Log.info(e.message)
  Chef::Log.info("LWRP for sudo is not defined. Skipping resource sudo[zabbix-iostat] ...")
end

if ::File.exists?("/proc/mdstat")
  include_recipe "zabbix-agent::mdraid"
end

# vim: ts=2 sw=2 et ai
