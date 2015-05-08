#IP config
{% set CON_MGNT_IP = '10.10.10.51' %}
{% set CON_EXT_IP = '192.168.5.51' %}
{% set TUNNEL_IP = grains['ip_interfaces']['eth0'][0] %}
{% set EXTERNAL_IP = grains['ip_interfaces']['eth1'][0] %}
{% set EXTERNAL_INTERFACE = 'eth1' %}

# Set password
{% set DEFAULT_PASS = 'Welcome123' %}
{% set RABBIT_PASS = 'e1f7faa4b4469eca70ba' %}
{% set MYSQL_PASS = 'a87eefad2e593bc88bb4' %}
{% set TOKEN_PASS = '15665d2c3994495dade3' %}
{% set ADMIN_PASS = 'f0290c8447ff2c7e5962' %}
{% set DEMO_PASS = '90d42e90248622237322' %}
{% set SERVICE_PASSWORD = '5467d3c0a37f1e300e90' %}
{% set METADATA_SECRET = '31e348255475451b9396' %}

{% set SERVICE_TENANT_NAME = 'service' %}
{% set ADMIN_TENANT_NAME = 'admin' %}
{% set DEMO_TENANT_NAME = 'demo' %}
{% set INVIS_TENANT_NAME = 'invisible_to_admin' %}
{% set ADMIN_USER_NAME = 'admin' %}
{% set DEMO_USER_NAME = 'demo' %}

# Environment variable for OPS service
{% set KEYSTONE_PASS = '876ccfd83bf0b69b0d32' %}
{% set GLANCE_PASS = '48336b5820bc15268f86' %}
{% set NOVA_PASS = 'db3a0acc3e120e30a909' %}
{% set NEUTRON_PASS = '3960626306894f919334' %}
{% set CINDER_PASS = 'da730c473f9cfaea58e3' %}

# Environment variable for DB
{% set KEYSTONE_DBPASS = 'de3b8bf2afeebbdddb4c' %}
{% set GLANCE_DBPASS = 'd5267c9ba905448c5757' %}
{% set NOVA_DBPASS = '981aef331d299cdcaec9' %}
{% set NEUTRON_DBPASS = 'bb71c3dd1c14b7fe7ecf' %}
{% set CINDER_DBPASS = 'b2d556cdd859642e60d5' %}

# User declaration in Keystone
{% set ADMIN_ROLE_NAME = 'admin' %}
{% set MEMBER_ROLE_NAME = 'Member' %}
{% set KEYSTONEADMIN_ROLE_NAME = 'KeystoneAdmin' %}
{% set KEYSTONESERVICE_ROLE_NAME = 'KeystoneServiceAdmin' %}

#{% set OS_SERVICE_TOKEN = '7fdbef0d4f8af31a09a9' %}

  
ntp:
 update: {{ CON_MGNT_IP }}

rabbit:
 pkgs:
  - rabbitmq-server
 bind-address: {{ CON_MGNT_IP  }}
 guest_user_pass: {{ RABBIT_PASS }}

mysql:
  server:
    config_file: salt://mysql/files/my.cnf
    root_password: {{ MYSQL_PASS }}
    bind-address: 0.0.0.0
    ip: {{ CON_MGNT_IP }}
    port: 3306
  users:
    - name: keystone
      host: ['localhost', '%']
      password: {{ KEYSTONE_DBPASS }}
      privileges: all privileges
      database_name: keystone
    - name: cinder
      host: ['localhost', '%']
      password: {{ CINDER_DBPASS }}
      privileges: all privileges
      database_name: cinder
    - name: nova
      host: ['localhost', '%']
      password: {{ NOVA_DBPASS }}
      privileges: all privileges
      database_name: nova
    - name: glance
      host: ['localhost', '%']
      password: {{ GLANCE_DBPASS }}
      privileges: all privileges
      database_name: glance
    - name: neutron
      host: ['localhost', '%']
      password: {{ NEUTRON_DBPASS }}
      privileges: all privileges
      database_name: neutron
  databases:
    - keystone
    - cinder
    - nova
    - glance
    - neutron

keystone:
 pkgs:
  - keystone
  - python-keystoneclient
 admin_token: {{ TOKEN_PASS }}
 admin_password: {{ ADMIN_PASS }}
 dbname: 'keystone'
 dbuser: 'keystone'
 dbpass: {{ KEYSTONE_DBPASS }}
 bind-address: {{ CON_MGNT_IP }}
 
users:
  - name: admin
    password: {{ ADMIN_PASS }}
    tenant: admin
    roles: ['admin', '_member_']
    email: ducnc92@hotmail.com
  - name: glance
    password: {{ GLANCE_PASS }}
    tenant: service
    roles: ['admin']
    email: ducnc92@hotmail.com
  - name: cinder
    password: {{ CINDER_PASS }}
    tenant: service
    roles: ['admin']
    email: ducnc92@hotmail.com
  - name: nova
    password: {{ NOVA_PASS }}
    tenant: service
    roles: ['admin']
    email: ducnc92@hotmail.com
  - name: neutron
    password: {{ NEUTRON_PASS }}
    tenant: service
    roles: ['admin']
    email: ducnc92@hotmail.com

services:
   - name: glance
     description: OpenStack Image Service
     type: image
   - name: keystone
     description: OpenStack Identity
     type: identity
   - name: nova
     description: OpenStack Compute
     type: compute
   - name: cinder
     description: OpenStack Block Storage
     type: volume
   - name: cinderv2
     description: OpenStack Block Storage v2
     type: volumev2
   - name: neutron
     description: OpenStack Networking
     type: network

tenants:
  - name: demo
    description: Demo Tenant
  - name: admin
    description: Admin Tenant
  - name: service
    description: Service Tenant

roles:
  - admin
  - _member_


endpoints:
  - name: keystone
    publicurl: 'http://{{ CON_MGNT_IP }}:5000/v2.0'
    internalurl: 'http://{{ CON_MGNT_IP }}:5000/v2.0'
    adminurl: 'http://{{ CON_MGNT_IP }}:35357/v2.0'
    type: identity

  - name: glance
    publicurl: 'http://{{ CON_MGNT_IP }}:9292'
    internalurl: 'http://{{ CON_MGNT_IP }}:9292'
    adminurl: 'http://{{ CON_MGNT_IP }}:9292'
    type: image

  - name: nova
    publicurl: 'http://{{ CON_MGNT_IP }}:8774/v2/%\(tenant_id\)s'
    internalurl: 'http://{{ CON_MGNT_IP }}:8774/v2/%\(tenant_id\)s'
    adminurl: 'http://{{ CON_MGNT_IP }}:8774/v2/%\(tenant_id\)s'
    type: compute

  - name: cinder
    publicurl: 'http://{{ CON_MGNT_IP }}:8776/v1/%\(tenant_id\)s'
    internalurl: 'http://{{ CON_MGNT_IP }}:8776/v1/%\(tenant_id\)s'
    adminurl: 'http://{{ CON_MGNT_IP }}:8776/v1/%\(tenant_id\)s'
    type: volume

  - name: cinderv2
    publicurl: 'http://{{ CON_MGNT_IP }}:8776/v2/%\(tenant_id\)s'
    internalurl: 'http://{{ CON_MGNT_IP }}:8776/v2/%\(tenant_id\)s'
    adminurl: 'http://{{ CON_MGNT_IP }}:8776/v2/%\(tenant_id\)s'
    type: volumev2

  - name: neutron
    publicurl: 'http://{{ CON_MGNT_IP }}:9696'
    internalurl: 'http://{{ CON_MGNT_IP }}:9696'
    adminurl: 'http://{{ CON_MGNT_IP }}:9696'
    type: network

glance:
 pkgs:
  - glance
  - python-glanceclient
 dbname: 'glance'
 dbpass: {{ GLANCE_DBPASS }}
 dbuser: 'glance'
 dburl: {{ CON_MGNT_IP }}
 tenant: service
 username: glance
 password: {{ GLANCE_PASS }}
 bind-address: {{ CON_MGNT_IP }}
 cirros_url: 'http://cdn.download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img'
 services:
  - glance-registry
  - glance-api

nova-api:
 pkgs:
  - nova-api
  - nova-cert
  - nova-conductor
  - nova-consoleauth
  - nova-novncproxy
  - nova-scheduler
  - python-novaclient
  - libguestfs-tools 
 dbname: 'nova'
 dbuser: 'nova'
 dbpass: {{ NOVA_DBPASS }}
 tenant: service
 username: nova
 password: {{ NOVA_PASS }}
 vncserver_listen: {{ CON_MGNT_IP }}
 vncserver_proxyclient_address: {{ CON_MGNT_IP }}
 bind-address: {{ CON_MGNT_IP }}
 services:
  - nova-api
  - nova-cert
  - nova-consoleauth
  - nova-scheduler
  - nova-conductor
  - nova-novncproxy
  
nova-compute:
 pkgs:
  - nova-compute 
  - sysfsutils
  - libguestfs-tools 
 tunnel_ip: {{ TUNNEL_IP }}
 proxy_ip: {{ CON_EXT_IP }}
 dbname: 'nova'
 dbuser: 'nova'
 dbpass: {{ NOVA_DBPASS }}
 tenant: service
 username: nova
 password: {{ NOVA_PASS }}
 service:
  - nova-compute

neutron-api-server:
 pkgs:
  - neutron-server
  - neutron-plugin-ml2
  - python-neutronclient
 dbname: 'neutron'
 dbuser: 'neutron'
 dbpass: {{ NEUTRON_DBPASS }}
 tenant: service
 bind-address: {{ CON_MGNT_IP }}
 metadata_secret: {{ METADATA_SECRET }}
 metadata_server: {{ CON_MGNT_IP }}
 username: 'neutron'
 password: {{ NEUTRON_PASS }}
 services:
  - neutron-server

neutron-network:
 pkgs:
  - neutron-common
  - neutron-plugin-ml2
  - neutron-plugin-openvswitch-agent
  - neutron-l3-agent
  - neutron-dhcp-agent
 tunnel_ip: {{ TUNNEL_IP }}
 external_if: {{ EXTERNAL_INTERFACE }}
 external_ip: '192.168.5.52'
 gateway: '192.168.5.1'
 netmask: '255.255.255.0'
 services:
  - openvswitch-switch
  - neutron-plugin-openvswitch-agent
  - neutron-l3-agent
  - neutron-dhcp-agent
  - neutron-metadata-agent

neutron-openvswitch:
 pkgs:
  - openvswitch-controller
  - openvswitch-switch
  - openvswitch-datapath-dkms
  - python-mysqldb
  
neutron-agent:
 pkgs:
  - neutron-common 
  - neutron-plugin-ml2 
  - neutron-plugin-openvswitch-agent 
  - openvswitch-datapath-dkms 
 compute_data_ip: {{ TUNNEL_IP }}
 services:
  - nova-compute 
  - openvswitch-switch
  - neutron-plugin-openvswitch-agent
 
horizon:
 pkgs:
  - apache2
  - memcached
  - libapache2-mod-wsgi
  - openstack-dashboard
 absent_pkgs:
  - openstack-dashboard-ubuntu-theme
 services:
  - apache2 
  - memcached

cinder:
 pkgs:
  - cinder-api
  - cinder-scheduler
  - python-cinderclient
 cinder-api-ip: {{ CON_MGNT_IP }}
 dbname: 'cinder'
 dbpass: {{ CINDER_DBPASS }}
 dbuser: 'cinder'
 tenant: service
 username: cinder
 password: {{ CINDER_PASS }}
 services:
  - cinder-scheduler
  - cinder-api
  
cinder-volume:
 STO_MGNT_IP: 10.10.10.55
 pkgs:
  - lvm2
  - cinder-volume
 services:
  - cinder-volume
  - tgt
  