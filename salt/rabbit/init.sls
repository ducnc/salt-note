{% for pkg in salt['pillar.get']('rabbit:pkgs', []) %}
pkg_{{ pkg }}:
 pkg.installed:
  - refresh: False
  - name: {{ pkg }}
{% endfor %}

 service.running:
  - name: rabbitmq-server
  - require:
     - pkg: rabbitmq-server
 cmd.run:
  - name: rabbitmqctl change_password guest {{ pillar['rabbit']['guest_user_pass']}}
  - require:
     - service: rabbitmq-server


