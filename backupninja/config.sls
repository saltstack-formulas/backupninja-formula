# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "backupninja/map.jinja" import backupninja with context %}

backupninja-config:
  file.managed:
    - name: {{ backupninja.configfile }}
    - source: salt://backupninja/files/backupninja.conf.jinja
    - template: jinja
    - mode: 644
    - check_cmd: "{{ backupninja.executable }} --test --conffile"

{%  for filename, config in salt["pillar.get"]('backupninja:actions', {})|dictsort %}
{%    set type = filename.split('.')|last %}
backupninja-action-{{ filename }}:
  file.managed:
    - name: {{ backupninja.config.configdirectory }}/{{ filename }}
    - require_in:
      - file: backupninja-config  # use its check_cmd
    - mode: 640
{#
      +++++ shell actions +++++ #}
{%-   if type == 'sh' %}
{%-     if config is iterable %}
    - template: jinja
{%-       if "start_services" in config %}
    - source: salt://backupninja/files/start_services.sh.jinja
    - context:
        services: {{ config.start_services }}
{%-       elif "stop_services" in config %}
    - source: salt://backupninja/files/stop_services.sh.jinja
    - context:
        services: {{ config.stop_services }}
{%-       endif %}
{%-     else %}
    - contents: |
        {{ config | indent(8) }}
{%-     endif %}
{#-
      +++++ unknown action +++++ #}
{%-   else %}
    - contents: |
        {{ config | indent(8) }}
{%-   endif %}
{%- endfor %}
