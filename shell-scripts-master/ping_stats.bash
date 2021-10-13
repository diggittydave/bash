#!/bin/bash
#Commands written by chq-davidwe
#
#these scripts should be run from your chq login only. 
#
#If you have questions, or something isn't working right, contact chq-davidwe.
#
#This command must be run from your chq login to unix. 
# run pingstats from one branch to another and log the results in a text file. 
me=`whoami`;read -p "Which branch are we testing? " bbb;ping -s $bbb.$bbb.ei 1500 100 >> /export/home/$me/pingstats_${HOSTNAME}_to_$bbb.txt
