#!/bin/bash

# http://serverfault.com/questions/244944/linux-ata-errors-translating-to-a-device-name

# on Ubuntu get ata ID for block devices sd*
ls -l /sys/block/s* \
	| sed -e 's^.*-> \.\.^/sys^' \
	       -e 's^/host^ ^'        \
	              -e 's^/target.*/^ ^'   \
		      | while read Path HostNum ID
  do
	       echo ${ID}: $(cat $Path/host$HostNum/scsi_host/host$HostNum/unique_id)
  done
