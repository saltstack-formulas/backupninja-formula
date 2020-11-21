# -*- coding: utf-8 -*-
# vim: ft=yaml
---
backupninja:
  lookup:
    pkg: backupninja
    action_defaults:
      rsync:
        general:
          mountpoint: /mnt/backup
          backupdir: myserver
          format: short
          days: 7
        source:
          from: local
          include:
            - /etc
            - /var/backups/
          exclude:
            - exclude_folder1
            - exclude_folder2
        dest:
          dest: remote
          user: myuser
          id_file: /root/.ssh/id_rsa

  actions:
    11-custom.sh: |
      sleep 1
    12-custom-rsync.sh:
      rsync:
        command: rsync
        port: 22
        log: /var/log/backup/custom-rsync.log
        truncate_log: 'False'
        from: /etc/ /var/backups/
        to: user@host:backup
        args: --recursive --times --delete
