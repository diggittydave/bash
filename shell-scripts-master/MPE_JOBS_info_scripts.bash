#!/bin/bash
#Commands written by chq-davidwe
#
#these scripts should be run from your chq login only. 
#
#If you have questions, or something isn't working right, contact chq-davidwe.


# reads the end of the last 20 jobs with the given name. drops them into your home directory in a tar.gz for downloading.
read -p "WHICH JOB? " JOBNAME;me=`whoami`;jobs=`lso $JOBNAME |tail -23|head -n 20|awk '{print $1}'`;for job in $jobs; do echo `MOREJEND $job >>/export/home/$me/$JOBNAME.$job.Job.End`;done;tar cvf /export/home/$me/$JOBNAME.tar *.End;rm /export/home/$me/*.End;gzip /export/home/$me/*.tar;echo "/export/home/$me/$JOBNAME.End.tar.gz is ready for you to download"


# abort the last running job with a given job name.
read -p "which job are we killing? " jobname; $job=`lso $jobname|awk '{print $1}'|tail -4|head -n 1`; echo "ABORTJOB $job"|n


# Shows the last job status for a given job name.
read -p "Which job are you looking for? " JOBNAME;lso $JOBNAME|awk '{print $1,$4,$7,$8}'