maintainer        "Kirill Kouznetsov"
maintainer_email  "agon.smith@gmail.com"
license           "Apache 2.0"
description       "Installs and configures zabbix agent"
version           "1.1.10"

recipe            "zabbix-agent", "Installs and configures zabbix agent"

%w{ ubuntu debian }.each do |os|
  supports os
end
