#!/bin/bash
#Commands written by chq-davidwe
#
#these scripts should be run from your chq login only. 
#
#If you have questions, or something isn't working right, contact chq-davidwe.
#
# pull the entry response from a given historical day.
me=`whoami`;read -p "What is the Entry Number?: " entry; read -p "What date? YYYY-MM-DD: " date;sudo gzgrep "$entry" /logs/jvm/customs/web/customs/UsWebServices/UsWebServices.$date.*.log.gz | grep "Response" >> /export/home/$me/$entry.txt