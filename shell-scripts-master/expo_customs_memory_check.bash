#!/bin/bash
#Commands written by chq-davidwe
#
#these scripts should be run from your chq login only. 
#
#If you have questions, or something isn't working right, contact chq-davidwe.
#
#This command must be run from your chq login to unix.
# looks for Out of Memory errors in the current day's expo customs weblog.
day=`date | awk '{print $3}'`;list=`ls -lahrt /logs/jvm/customs/web/*.out|grep $day|awk '{print $9}'`;for file in $list; do echo `grep "Memory" $file|grep -v "SEVERE"|grep -v "Polling"`;done;
