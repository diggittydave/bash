#!/bin/bash
#Commands written by chq-davidwe
#
#these scripts should be run from your chq login only. 
#
#If you have questions, or something isn't working right, contact chq-davidwe.
#
#
# pull the entry response for a given entry number on the current day.
me=`whoami`;read -p "ENTRY #: " entry;sudo grep "$entry" /logs/jvm/customs/web/customs/UsWebServices.log | grep "Response" |sed 's/^[^<?]*<?/<?/' >> /export/home/$me/$entry.xml;gzip /export/home/$me/$entry.xml;
