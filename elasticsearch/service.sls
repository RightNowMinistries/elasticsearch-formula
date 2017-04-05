include:
  - elasticsearch.pkg
  - elasticsearch.config

elasticsearch_service_config:
  file.managed:
    - name: /etc/systemd/system/elasticsearch.service.d/elasticsearch.conf
    - source: salt://elasticsearch/files/elasticsearch.service.conf
    - makedirs: True
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: elasticsearch_service_config

elasticsearch_service:
  service.running:
    - name: elasticsearch
    - enable: True
{%- if salt['pillar.get']('elasticsearch:config') %}
    - watch:
      - file: elasticsearch_cfg
      - file: elasticsearch_service_config
{%- endif %}
    - require:
      - pkg: elasticsearch
