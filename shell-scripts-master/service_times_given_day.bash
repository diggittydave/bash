#!/bin/bash
#Commands written by chq-davidwe
#
#these scripts should be run from your chq login only. 
#
#If you have questions, or something isn't working right, contact chq-davidwe.
# finds service elaped times for the current day. This is helpful for pinpointing external service issues.
# command to find all service call times in tipsi logs for a given day.
# converts the data to a .csv and places it in your home directory.
read -p "Which Day are we looking for? " day;short=`echo $day|sed 's/\ //g'`;me=`whoami`;list=`ls -lahrt /logs/tipsi|grep "$day"|grep "tipsid.*.*.log"|awk '{print $9}'`;for file in $list; do echo `echo looking in $file;gzgrep "Service Elapsed" /logs/tipsi/$file|sed 's/\ /\,/g'|sed 's/\,\,/\,/g'|sed 's/\,\,/\,/g' >> /export/home/$me/services_for_$short.csv`;done;
