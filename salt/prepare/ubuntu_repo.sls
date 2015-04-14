ubuntu_cloud_keyring_install:
  pkg:
    - installed
    - name: ubuntu-cloud-keyring
    - refresh: True

cloudarchive_juno:
  file.managed:
    - name: /etc/apt/sources.list.d/cloudarchive-juno.list
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://prepare/files/cloudarchive-juno.list
