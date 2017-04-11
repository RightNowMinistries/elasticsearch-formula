include:
  - elasticsearch.pkg
  - elasticsearch.service


{%- set major_version = salt['pillar.get']('elasticsearch:major_version', 2) %}
{%- set java_home = salt['pillar.get']('elasticsearch:sysconfig:JAVA_HOME', '/usr/lib/java') %}
{%- set plugins_pillar = salt['pillar.get']('elasticsearch:plugins', {}) %}

{% if major_version == 5 %}
  {%- set plugin_bin = 'elasticsearch-plugin' %}
{% else %}
  {%- set plugin_bin = 'plugin' %}
{% endif %}

{% for name, repo in plugins_pillar.items() %}
elasticsearch-{{ name }}:
  cmd.run:
    - name: /usr/share/elasticsearch/bin/{{ plugin_bin }} install -b {{ repo }}
    - env:
      - JAVA_HOME: {{ java_home }}
    - require:
      - sls: elasticsearch.pkg
    - watch_in:
      - service: elasticsearch_service
    - unless: /usr/share/elasticsearch/bin/{{ plugin_bin }} list | grep {{ name }}
{% endfor %}
