{% from "mariadb/default.yml" import rawmap with context %}
{% set mariadb = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mariadb')) %}

mariadb_config:
    file:
        - managed
        - name: {{mariadb.config.file}}
        - source: salt://mariadb/files/my.cnf
        - template: jinja
        - user: root
        - group: wheel
        - mode: 0644
