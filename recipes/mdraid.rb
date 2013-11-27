#
# Cookbook Name:: zabbix-agent
# Recipe:: mdraid
#

directory "/opt/chef/zabbix/" do
  owner "root"
  group "root"
  mode 0755
  recursive true
end

cookbook_file "/etc/zabbix/agent-conf.d/mdadm.conf" do
  owner "root"
  group "root"
  mode 0644
  source "mdadm.conf"
  notifies :restart, "service[#{node['zabbix']['service']}]", :delayed
end

# vim: ts=2 sw=2 et ai
