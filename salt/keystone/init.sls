include:
 - mysql
 
# Install pakages
keystone_pkgs:
 pkg.installed:
   - refresh: False
   - pkgs:
{% for pkg in salt['pillar.get']('keystone:pkgs', []) %}
      - {{ pkg }}
{% endfor %}

 file.managed:
  - name: /etc/keystone/keystone.conf
  - source: salt://keystone/files/keystone.conf
  - template: jinja
  - user: root
  - group: root
  - mode: 644
  - require:
     - pkg: keystone_pkgs

 cmd.run:
  - name: keystone-manage db_sync
  - unless: mysql -e 'show tables from {{ pillar['keystone']['dbname'] }}' | grep user
  - require:
     - service: mysql
     - mysql_database: create_database_{{ pillar['keystone']['dbname'] }}
     - file: /etc/keystone/keystone.conf
     
 service.running:
  - name: keystone
  - watch:
     - file: /etc/keystone/keystone.conf
     - cmd: keystone-manage db_sync
  - require:
     - pkg: keystone_pkgs
     
#file.openrc:
# file.managed:
#  - name: /root/adminopenrc
#  - source: salt://keystone/files/openrc
#  - template: jinja
#  - user: root
#  - group: root
#  - mode: 644

/var/lib/keystone/keystone.db:
 file:
  - absent
  - require:
     - pkg: keystone_pkgs

/usr/bin/keystone-manage token_flush >/var/log/keystone/keystone-tokenflush.log 2>&1:
 cron.present:
  - user: root
  - minute: 1
