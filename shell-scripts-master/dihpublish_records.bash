#!/bin/bash
#Commands written by chq-davidwe
#
#these scripts should be run from your chq login only. 
#
#If you have questions, or something isn't working right, contact chq-davidwe.
#
#This command must be run from your chq login to unix. 
#Finds all instances of a file's updates inside the dihpublish logs and puts it in a file.
#the file is then emailed with the contents to the import helpdesk.
read -p "Which file number? " file;me=`whoami`;gzgrep -h "$file" /logs/mpe/import/dihpublish/${HOSTNAME^^}/* >> /export/home/$me/$file.txt;mailx -s "$file" import.helpdesk@expeditors.com < /export/home/$me/$file.txt
