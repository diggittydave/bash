#!/bin/bash
#Commands written by chq-davidwe
#
#these scripts should be run from your chq login only. 
#
#If you have questions, or something isn't working right, contact chq-davidwe.
#
# finds all inquire jobs and shows the last time each ran and its status.
jobs=`ls -l /prod/mpe/IMPORT/JOB|awk '{print $9}'; ls -la /prod/mpe/EXPORT/JOB|awk '{print $9}';`;for job in $jobs; do echo `echo $job;lso $job|awk '{print $1,$4,$7,$8}'|tail -4|head -n 1`; done;
