# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "backupninja/map.jinja" import backupninja with context %}

backupninja-pkg:
  pkg.installed:
    - name: {{ backupninja.pkg }}
    - install_recommends: {{ backupninja.install_recommends }}

{%- for pkg in backupninja.additional_pkgs %}
backupninja-pkg-{{ pkg }}:
  pkg.installed:
    - name: {{ pkg }}
{%- endfor %}
