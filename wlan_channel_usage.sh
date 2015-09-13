#!/bin/bash

if [[ $# -ne 1 ]];
then
	echo -e "\nUsage: WLAN_DEVICE\n";
	echo -e "\nList of possible WLAN interfaces:\n";
	echo -e "`iwconfig 2>/dev/null`";
	exit;
fi

iwlist $1 scan |grep Frequency | uniq -c | sort -n -k 5 
