# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "backupninja/map.jinja" import backupninja with context %}

backupninja-config:
  file.managed:
    - name: {{ backupninja.config }}
    - source: salt://backupninja/files/backupninja.conf.jinja
    - mode: 644
    - user: root
    - group: root
