{% from "mariadb/default.yml" import rawmap with context %}
{% set rawmap = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mariadb')) %}

{% if 'databases' in rawmap %}
    {% if rawmap.databases is string %}
        {% set dbs = [rawmap.databases] %}
    {% else %}
        {% set dbs = rawmap.databases %}
    {% endif %}
    {% for db in dbs %}
        {% set username = None %}
        {% if db is mapping %}
            {% set dbname = db.items()[0][0] %}
            {% if 'user' in db.items()[0][1] %}
                {% set username = db.items()[0][1].user %}
            {% endif %}
        {% elif db is string %}
            {% set dbname = db %}
        {% endif %}

{{'mariadb_database_' ~ dbname}}:
    mysql_database:
        - present
        - name: {{dbname}}
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

        {% if username %}
{{'mariadb_grants_' ~ dbname ~ '_' ~ username}}:
    mysql_grants:
        - present
        - grant: all privileges
        - database: {{dbname ~ '.*'}}
        - user: {{username}}
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
        {% endif %}
    {% endfor %}
{% endif %}
