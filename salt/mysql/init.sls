include:
  - python-mysql

# Install pkg
mysql:
  pkg.installed:
    - refresh: False
    - name: mysql-server
  file.managed:
    - name: /etc/mysql/my.cnf
    - source: {{ pillar['mysql']['server']['config_file'] }}
    - mode: 644
    - user: root
    - template: jinja
    - group: root
  service.running:
    - name: mysql
    - require:
        - pkg: mysql-server
    - watch:
        - file: mysql

set_localhost_root_password:
  mysql_user.present:
    - name: root
    - host: localhost
    - password: {{ pillar['mysql']['server']['root_password'] }}
    - connection_pass: ""
    - watch:
      - pkg: mysql-server
      - service: mysql
      
# Create databases
{% for db in salt['pillar.get']('mysql:databases', []) %}
create_database_{{ db }}:
  mysql_database.present:
    - connection_user: root
    - connection_pass: {{ pillar['mysql']['server']['root_password'] }}
    - name: {{ db }}
    - require:
        - pkg: python-mysql
        - service: mysql
{% endfor %}
    
    
{% for user in salt['pillar.get']('mysql:users', []) %}
{% for host in user['host'] %}
# Create user
create_user_{{ user['name'] }}_{{ host }}:
  mysql_user.present:
    - name: {{ user['name'] }}
    - host: "{{ host }}"
    - password: {{ user['password'] }}
    - connection_user: root
    - connection_pass: {{ pillar['mysql']['server']['root_password'] }}
    - require:
      - pkg: python-mysql
      - service: mysql

# Grant access for user
  mysql_grants.present:
    - grant: {{ user['privileges'] }}
    - database: "{{ user['database_name'] }}.*"
    - connection_user: root
    - connection_pass: {{ pillar['mysql']['server']['root_password'] }}
    - user: {{ user['name'] }}
    - host: "{{ host }}"
    - require:
      - mysql_user: create_user_{{ user['name'] }}_{{ host }}
      - mysql_database: create_database_{{ user['database_name'] }}
{% endfor %}
{% endfor %}
