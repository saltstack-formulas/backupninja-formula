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

{%  for filename, config_update in salt["pillar.get"]('backupninja:actions', {})|dictsort %}
{%-   set type = filename.split('.')|last %}
{%-   if config_update is string %}
{%-     set config = config_update %}
{%-   else %}
{%-     set config = backupninja.action_defaults.get(type, {}) %}
{%-     set config = salt['defaults.merge'](config, config_update) %}
{%-   endif %}
backupninja-action-{{ filename }}:
  file.managed:
    - name: {{ backupninja.config.configdirectory }}/{{ filename }}
    - require_in:
      - file: backupninja-config  # use its check_cmd
    - mode: 640
    - context:
        config: {{ config }}
{%    if not config is string %}
{#-
      +++++ shell actions +++++ #}
{%-     if type == 'sh' %}
    - template: jinja
{%-       if "start_services" in config %}
    - source: salt://backupninja/files/start_services.sh.jinja
{%-       elif "stop_services" in config %}
    - source: salt://backupninja/files/stop_services.sh.jinja
{%-       endif %}
{%-     else %}
{#
      +++++ default: ini-style actions +++++ #}
    - template: jinja
    - source: salt://backupninja/files/ini.jinja
{%-     endif %}
{%-   else %}
    - contents: |
        {{ config | indent(8) }}
{%-   endif %}
{%- endfor %}
