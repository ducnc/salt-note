base:
  'controller':
    - hosts
    - prepare
    - ntp
    - rabbit
    - mysql
    - keystone
    - keystone.create-user-tenant
    - glance
    - nova.nova-api
    - neutron.api
    - cinder.api
    - horizon

  'network*':
    - hosts
    - prepare
    - ntp
    - python-mysql
    - neutron.openvswitch
    - neutron.network
    
  'compute*':
    - hosts
    - prepare
    - ntp
    - python-mysql
    - nova.nova-compute
    - neutron.agent

  'cinder*':
    - hosts
    - prepare
    - ntp
    - cinder.volume
