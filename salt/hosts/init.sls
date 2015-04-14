{{ grains['id'] }}:
 host.present:
  - ip: {{ grains['ip_interfaces']['eth0'][0]}} 
