#!/bin/bash

# chmod +x this file
# usage: /path/to/backup.sh origin1 origin2 origin3 ...
# origin example: user@host:/path/to/folder # with trailing slash to copy contents, without to copy folder
# origins are copied to /path/to/backup along with the sync log and active crontab

backup="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P )/backup" # path/to/backup
log="${backup}/rsync.log"
cron="${backup}/cron"

# create structure if inexistent
mkdir -p $backup && touch $log $cron

# stamp log entry
echo -e "\n* $(date)" >> $log

# sync and log
for origin in $@; do
	echo -e "\n${origin}" >> $log && rsync -azpvh6b --backup-dir=.old $origin $backup --delete-after >> $log
done

#backup cron
crontab -l > $cron