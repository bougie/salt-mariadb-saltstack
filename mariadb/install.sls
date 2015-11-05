{% from "mariadb/default.yml" import rawmap with context %}
{% set mariadb = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mariadb')) %}

mariadb_server_package:
    pkg.installed:
        - name: {{mariadb.server_package}}
        - reload_modules: True

mariadb_client_package:
    pkg.installed:
        - name: {{mariadb.client_package}}
        - reload_modules: True

{% if mariadb.admin %}
python_mariadb:
    pkg.installed:
        - name: {{mariadb.pymysql}}
        - reload_modules: True
{% endif %}
