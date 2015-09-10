#!/bin/bash

# https://stackoverflow.com/questions/5296667/pdftk-compression-option
# https://superuser.com/questions/435410/where-are-ghostscript-options-switches-documented

if [[ $# -ne 2 ]];
then
	echo -e "\nUsage: INPUT OUTPUT\n";
	exit;
fi

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dNOPAUSE -dBATCH  -dQUIET -sOutputFile=$2 $1
