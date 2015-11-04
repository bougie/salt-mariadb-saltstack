{% from "mariadb/default.yml" import rawmap with context %}
{% set rawmap = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mariadb')) %}

{% if 'master_user' in rawmap %}
mariadb_master_password:
    cmd.run:
        - name: mysqladmin --user {{rawmap.master_user.username}} password '{{rawmap.master_user.password|replace("'", "'\"'\"'")}}'
        - unless: mysql --user {{rawmap.master_user.username}} --password='{{rawmap.master_user.password|replace("'", "'\"'\"'")}}' --execute="SELECT 1;"
{% endif %}

{% if 'users' in rawmap and rawmap.users is mapping %}
    {% for user, config in rawmap.users.items() %}
{{'mariadb_user_' ~ user}}:
    mysql_user:
        - present
        - name: {{user}}
        {% if 'password_hash' in config %}
        - password_hash: {{config.password_hash}}
        {% else %}
        - password: {{config.password}}
        {% endif %}
        - host: {{config.host}}
        {% if 'master_user' in rawmap %}
            {% set con = rawmap.master_user %}
            {% if 'host' in con %}
        - connection_host: {{con.host}}
            {% else %}
        - connection_host: localhost
            {% endif %}
            {% if 'port' in con %}
        - connection_port: {{con.port}}
            {% endif %}
            {% if 'username' in con %}
        - connection_user: {{con.username}}
            {% endif %}
            {% if 'password' in con %}
        - connection_pass: {{con.password}}
            {% endif %}
        {% endif %}
    {% endfor %}
{% endif %}
