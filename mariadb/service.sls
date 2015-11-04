{% from "mariadb/default.yml" import rawmap with context %}
{% set mariadb = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mariadb')) %}

mariadb_service:
    service:
        - running
        - name: {{mariadb.service}}
