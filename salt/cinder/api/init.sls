cinder_pkgs:
  pkg.installed:
   - refresh: False
   - pkgs:
{% for pkg in salt['pillar.get']('cinder:pkgs', []) %}
      - {{ pkg }}
{% endfor %}

cinder.conf:
 file.managed:
  - name: /etc/cinder/cinder.conf
  - user: cinder
  - group: cinder
  - mode: 644
  - source: salt://cinder/api/files/cinder-{{ grains['os'] }}.conf
  - template: jinja
  - require:
     - pkg: cinder_pkgs

{% for service in salt['pillar.get']('cinder:services', []) %}
service_{{ service }}:
 service.running:
  - name: {{ service }}
  - require:
     - pkg: cinder_pkgs
  - watch:
     - file: cinder.conf
     - cmd: cinder_syndb
{% endfor %}

cinder_syndb:
 cmd.run:
  - name: cinder-manage db sync
  - unless: mysql -e 'show tables from {{ pillar['cinder']['dbname'] }}' | grep volume_types
  - require:
     - file: cinder.conf

