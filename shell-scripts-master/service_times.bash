#!/bin/bash
#Commands written by chq-davidwe
#
#these scripts should be run from your chq login only. 
#
#If you have questions, or something isn't working right, contact chq-davidwe.
# finds service elaped times for the current day. This is helpful for pinpointing external service issues.
day=`date | awk '{print $3}'`;list=`ls -lahrt /logs/tipsi|grep $day|grep "tipsid.*.*.log"|awk '{print $9}'`;for file in $list; do echo `grep "Service Elapsed" /logs/tipsi/$file|awk '{print $7,$8}'|sort -u`;done;
