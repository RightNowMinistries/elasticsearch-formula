include:
  - elasticsearch.pkg

{%- if salt['pillar.get']('elasticsearch:config') %}
elasticsearch_cfg:
  file.serialize:
    - name: /etc/elasticsearch/elasticsearch.yml
    - dataset_pillar: elasticsearch:config
    - formatter: yaml
    - user: root
    - require:
      - sls: elasticsearch.pkg
{%- endif %}

{% set data_dirs = salt['pillar.get']('elasticsearch:config:path.data') %}
{% set log_dir = salt['pillar.get']('elasticsearch:config:path.logs') %}

{% for dir in data_dirs %}
{% if dir %}
{{ dir }}:
  file.directory:
    - user: elasticsearch
    - group: elasticsearch
    - mode: 0700
    - makedirs: True
{% endif %}
{% endfor %}

{% if log_dir %}
elasticsearch_log_dir:
  file.directory:
    - name: {{ log_dir }}
    - user: elasticsearch
    - group: elasticsearch
    - mode: 0700
    - makedirs: True
{% endif %}
