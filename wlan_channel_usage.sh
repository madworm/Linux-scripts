#!/bin/bash

TEST_UID=`id | sed 's/uid=\([0-9]\{1,5\}\).*/\1/'`;

if [[ $TEST_UID -ne 0 ]];
then
	echo -e "\nMust be run as root!\n";
	exit;
fi

if [[ $# -ne 1 ]];
then
	echo -e "\nUsage: ${0#./} WLAN_DEVICE\n";
	echo -e "List of possible WLAN interfaces:\n";
	echo -e "`iwconfig 2>/dev/null`\n";
	echo -e "Run 'sudo -i ifconfig <net-dev> up' if scanning doesn't work.\n";
	exit;
fi

echo -e "\n";

iwlist $1 scan |grep Frequency | uniq -c | sort -n -k 5 | gawk '{print} {SUM=SUM+$1} END {print "\n      " SUM "\n"}';
