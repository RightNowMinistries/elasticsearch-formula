daily-scripts-directory:
  file.directory:
    - name: /etc/dailyscripts
    - mode: 755

add-cleanup-indices-script:
  file.managed:
    - name: /etc/dailyscripts/cleanup-indices.sh
    - source: salt://elasticsearch/files/cleanup-indices.sh
    - template: jinja

logs-directory:
  file.directory:
    - name: /logs
    - mode: 775

daily-cleanup-job:
  cron.present:
    - user: root
    - minute: 0
    - hour: 0
    - name: sh /etc/dailyscripts/cleanup-indices.sh >> /logs/cleanup-indices.log

create-logrotate-config-esindices:
  file.managed:
    - name: /etc/logrotate.d/es-indices
    - source: salt://elasticsearch/files/es-indices.logrotate.jinja
    - template: jinja