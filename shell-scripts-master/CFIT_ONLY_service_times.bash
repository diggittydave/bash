#!/bin/bash
#Commands written by chq-davidwe
#
#these scripts should be run from your chq login only. 
#
#If you have questions, or something isn't working right, contact chq-davidwe.
#
# command to find CFIT ONLY service call times in tipsi logs..
# converts data to a .csv and drops it in your home directory.
month=`date|awk '{print $2}'|cut -c -3`;day=`date|awk '{print $3}'|sed 's/\,//g'`;me=`whoami`;list=`ls -lahrt /logs/tipsi|grep "$month $day"|grep "tipsid.*.*.log"|awk '{print $9}'`;for file in $list; do echo `grep "Service Elapsed" /logs/tipsi/$file|grep -v "service=JsbDistributedMessaging"|grep -v "service=ExportNotificationFrameworkLegacyFacade"|sed 's/\ /\,/g'|sed 's/\,\,/\,/g'|sed 's/\,\,/\,/g' >> /export/home/$me/services_for_cfit.csv`;done;