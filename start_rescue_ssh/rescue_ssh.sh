#! /bin/sh
#
# Copyright (c) 2010 SuSE LINUX Products GmbH, Germany.  All rights reserved.
#
# Author: Werner Fink, 2010
#
# /etc/init.d/after.local
#
# script with local commands to be executed from init after all scripts
# of a runlevel have been executed.
#
# Here you should add things, that should happen directly after
# runlevel has been reached.
#

USER="dad";
SSH_PORT="66";
SSHD_BIN=`which sshd`;
CMD_LINE=/proc/cmdline;
LOOK_FOR="start_rescue_ssh";
RESULT=`grep $LOOK_FOR $CMD_LINE`;
EMAIL_FROM="dad@provider.com";
EMAIL_TO="son@somewhereelse.com";
EMAIL_SUBJECT="Fix dad's computer...";
EMAIL_TEXT="Fix dad's computer...\n\nShared: ssh -4 -p SSH_PORT -t -L 6900:localhost:5900 USER@REMOTE_IP 'x11vnc -ncache -localhost -display :0'\n\nStand-alone: ssh -4 -p SSH_PORT -t -L 6900:localhost:5900 USER@REMOTE_IP 'x11vnc -create -ncache -localhost'\n\nvncviewer -compresslevel 9 -quality 5 -encodings tight localhost:6900";

if [[ -n $RESULT ]]; then
	# make sure WiFi is really up
	# make sure WiFi is set to 'system' connection in NetworkManager, so it starts without user login
	sleep 60;

	echo "booted with 'start_rescue_ssh': starting ssh";
	logger "booted with 'start_rescue_ssh': starting sshd";

	# punch a hole into the firewall
	iptables -I INPUT 1 -p tcp --dport $SSH_PORT -j ACCEPT

	# start extra SSH server
	$SSHD_BIN -4 -p $SSH_PORT -o "PermitRootLogin no" -o "PubkeyAuthentication yes" -o "PasswordAuthentication no" -o "ChallengeResponseAuthentication no"

	IP_FILE=`sudo -u $USER mktemp`;
	sudo -u $USER sh -c "curl -s checkip.dyndns.org > $IP_FILE";
	REMOTE_IP=$(cat $IP_FILE | sed 's/^<.*Current\ IP\ Address:\ //' | sed 's/\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/');
	rm $IP_FILE;
	EMAIL_TEXT=$(echo $EMAIL_TEXT | sed "s/REMOTE_IP/$REMOTE_IP/g" | sed "s/USER/$USER/g" | sed "s/SSH_PORT/$SSH_PORT/g");
	sudo -u $USER sh -c "echo -e \"$EMAIL_TEXT\" | mail -s \"$EMAIL_SUBJECT\" -r \"$EMAIL_FROM\" \"$EMAIL_TO\"";
fi
