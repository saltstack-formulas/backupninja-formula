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
{%-   if config_update is mapping %}
{%-     set config = backupninja.action_defaults.get(type, {}) %}
{%-     set config = salt['defaults.merge'](config, config_update) %}
{%-   else %}
{%-     set config = config_update %}
{%-   endif %}
backupninja-action-{{ filename }}:
{%-   set name = backupninja.config.configdirectory + "/" + filename %}
{%    if config is sameas False %}
  file.absent:
    - name: {{ name }}
{%    else %}
  file.managed:
    - name: {{ name }}
    - mode: 640
    - context:
{%      if config is mapping and not config is string %}
        config: {{ config }}
{#-
      +++++ shell actions +++++ #}
{%-       if type == 'sh' %}
    - template: jinja
    - source: {{ config.get('template', 'salt://backupninja/files/generic.sh.jinja') }}
    - context:
        config: {{ config }}
{%-       else %}
{#
      +++++ default: ini-style actions +++++ #}
    - template: jinja
    - source: salt://backupninja/files/ini.jinja
{%-       endif %}
{%-     elif config is string %}
    - contents: |
        {{ config | indent(8) }}
{%-     endif %}
{%-   endif %}
    - require_in:
      - file: backupninja-config  # use its check_cmd
{%- endfor %}
