{% for pkg in salt['pillar.get']('neutron-openvswitch:pkgs', []) %}
pkg_{{ pkg }}:
 pkg.installed:
  - refresh: False
  - name: {{ pkg }}
{% endfor %}

add-port:
  cmd.run:
    - name: |
        ovs-vsctl add-br br-ex
        ovs-vsctl add-port br-ex {{pillar['neutron-network']['external_if']}}
    - unless: ovs-vsctl list-br | grep br-ex 
#    - require:
#      - service: openvswitch-switch

edit_network:
  file.managed:
    - name: /etc/network/interfaces
    - source: salt://neutron/openvswitch/files/interface
    - template: jinja
    - require:
      - cmd: add-port

restart_network:
  cmd.run:
    - name: ifdown -a && ifup -a
    - require:
      - file: edit_network