# Meta-state to fully install mariadb
{% from "mariadb/default.yml" import rawmap with context %}
{% set rawmap = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mariadb')) %}

include:
   - mariadb.install
   - mariadb.config
   - mariadb.service
{% if rawmap.admin %}
   - mariadb.users
   - mariadb.databases
{% endif %}

extend:
    mariadb_service:
        service:
            - watch:
                - file: mariadb_config
                - pkg: mariadb_server_package
            - require:
                - file: mariadb_config
    mariadb_config:
        file:
            - require:
                - pkg: mariadb_server_package
{% if rawmap.admin and 'master_user' in rawmap %}
    mariadb_master_password:
        cmd:
            - require:
                - service: mariadb_service
{% endif %}
