horizon_pkgs:
 pkg.installed:
   - refresh: False
   - pkgs:
{% for pkg in salt['pillar.get']('horizon:pkgs', []) %}
      - {{ pkg }}
{% endfor %}

{% for pkg in salt['pillar.get']('horizon:absent_pkgs', []) %}
absent_pkg_{{ pkg }}:
 pkg.purged:
  - name: {{ pkg }}
  - require:
     - pkg: horizon_pkgs
{% endfor %}

redirect_page:
 file.managed:
  - name: /var/www/html/index.html
  - user: root
  - group: root
  - mode: 644
  - source: salt://horizon/files/index.html
  - template: jinja

{% for service in salt['pillar.get']('horizon:services', []) %}
service_{{ service }}:
  service.running:
   - name: {{ service}}
   - watch:
      - file: redirect_page
   - require:
      - pkg: horizon_pkgs
{% endfor %}
