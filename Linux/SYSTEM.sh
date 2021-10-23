SYSTEM SH
#/bin/bash
Free -h > ~/backups/freemem/free_mem.txt
du -h > ~/backups/diskuse/disk_use.txt
df -h > ~/backups/freedisk/free_disk.txt
lsof > ~/backups/openlist/open_list.txt

