{% for pkg in salt['pillar.get']('cinder-volume:pkgs', []) %}
pkg_{{ pkg }}:
 pkg.installed:
  - refresh: False
  - name: {{ pkg }} 
{% endfor %}

/dev/sdb:
 lvm.pv_present:
  - name: /dev/sdb
  - require:
     - pkg: lvm2

cinder-volumes:
 lvm.vg_present:
  - devices: /dev/sdb
  - require:
     - lvm: /dev/sdb

cinder.conf:
 file.managed:
  - name: /etc/cinder/cinder.conf
  - user: cinder
  - group: cinder
  - mode: 644
  - source: salt://cinder/volume/files/cinder.conf
  - template: jinja
  - require:
{% for pkg in salt['pillar.get']('cinder-volume:pkgs', []) %}
     - pkg: pkg_{{ pkg }}
{% endfor %}

{% for svc in salt['pillar.get']('cinder-volume:services', []) %}
service_{{ svc }}:
 service.running:
  - name: {{ svc }}
  - require:
     - pkg: pkg_cinder-volume
  - watch:
     - file: cinder.conf
{% endfor %}
