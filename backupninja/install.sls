# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "backupninja/map.jinja" import backupninja with context %}

backupninja-pkg:
  pkg.installed:
    - name: {{ backupninja.pkg }}
