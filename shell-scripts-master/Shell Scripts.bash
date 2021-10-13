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


# finds all inquire jobs and shows the last time each ran and its status.
jobs=`ls -l /prod/mpe/IMPORT/JOB|awk '{print $9}'; ls -la /prod/mpe/EXPORT/JOB|awk '{print $9}';`;for job in $jobs; do echo `echo $job;lso $job|awk '{print $1,$4,$7,$8}'|tail -4|head -n 1`; done;


# This is a large scope job. It can return a lot of data
me=`whoami`;jobs=`ls -l /prod/mpe/CORP/JOB|awk '{print $9}';ls -l /prod/mpe/EICS/JOB|awk '{print $9}';ls -l /prod/mpe/EIFA/JOB|awk '{print $9}';ls -l /prod/mpe/EXPORT/JOB|awk '{print $9}';ls -l /prod/mpe/${HOSTNAME^^}/JOB|awk '{print $9}';ls -l /prod/mpe/IMPORT/JOB|awk '{print $9}';`;for job in $jobs; do echo `echo $job;echo $job>>/export/home/$me/alljobruntimes.txt; lso $job|tail -23|head -n 20|awk '{print $1,$2,$4,$7,$8}'>>/export/home/$me/alljobruntimes.txt`;done;



# kill all other sessions except yours.
me=`whoami`;export sessions=$(sj |  egrep "EXEC" | egrep -v "$me" | tr -s ' ' | cut -d ' ' -f 1 | cut -d 'S' -f 2); for session in $sessions; do echo "ABORTSESSION $session | n"; done ; export check=$( sj | egrep "EXEC|#J" | egrep -v "#S|EIFA|CORP|SCHED|SESSIONS|WAIT"); while [ -n "${check}" ]; do check=$(  sj | egrep "EXEC|#J" | egrep -v "#S|EIFA|CORP|SCHED|SESSIONS|WAIT" ) &&  sj | egrep "EXEC|#J" | egrep -v "#S|EIFA|CORP|SCHED|SESSIONS|WAIT" && sleep 10 && clear; done; echo All jobs are down


# one liner to kill sessions in mpe environment. 
export sessions=$(sj |  egrep "EXEC" | egrep -v "$user|EIFA|CORP|SCHED|SESSIONS|#J|REVIEW" | tr -s ' ' | cut -d ' ' -f 1 | cut -d 'S' -f 2); for session in $sessions; do echo "ABORTSESSION $session | n"; done ; export check=$( sj | egrep "EXEC|#J" | egrep -v "#S|EIFA|CORP|SCHED|SESSIONS|WAIT"); while [ -n "${check}" ]; do check=$(  sj | egrep "EXEC|#J" | egrep -v "#S|EIFA|CORP|SCHED|SESSIONS|WAIT" ) &&  sj | egrep "EXEC|#J" | egrep -v "#S|EIFA|CORP|SCHED|SESSIONS|WAIT" && sleep 10 && clear; done; echo All jobs are down


# command to find service call times in tipsi logs for the current date
month=`date|awk '{print $2}'|cut -c -3`;day=`date|awk '{print $3}'|sed 's/\,//g'`;me=`whoami`;list=`ls -lahrt /logs/tipsi|grep "$month $day"|grep "tipsid.*.*.log"|awk '{print $9}'`;for file in $list; do echo `grep "Service Elapsed" /logs/tipsi/$file|sed 's/\ /\,/g'|sed 's/\,\,/\,/g'|sed 's/\,\,/\,/g' >> /export/home/$me/services.csv`;done;


# command to find CFIT service call times in tipsi logs..
month=`date|awk '{print $2}'|cut -c -3`;day=`date|awk '{print $3}'|sed 's/\,//g'`;me=`whoami`;list=`ls -lahrt /logs/tipsi|grep "$month $day"|grep "tipsid.*.*.log"|awk '{print $9}'`;for file in $list; do echo `grep "Service Elapsed" /logs/tipsi/$file|grep -v "service=JsbDistributedMessaging"|grep -v "service=ExportNotificationFrameworkLegacyFacade"|sed 's/\ /\,/g'|sed 's/\,\,/\,/g'|sed 's/\,\,/\,/g' >> /export/home/$me/services_for_cfit.csv`;done;


# command to find all service call times in tipsi logs for a given day.
read -p "Which Day are we looking for? " day;short=`echo $day|sed 's/\ //g'`;me=`whoami`;list=`ls -lahrt /logs/tipsi|grep "$day"|grep "tipsid.*.*.log"|awk '{print $9}'`;for file in $list; do echo `echo looking in $file;gzgrep "Service Elapsed" /logs/tipsi/$file|sed 's/\ /\,/g'|sed 's/\,\,/\,/g'|sed 's/\,\,/\,/g' >> /export/home/$me/services_for_$short.csv`;done;


# this will find all tipsi logs and list them out with their details.
read -p "Which file number?" file;logs=`gzgrep -l "$file" /logs/tipsi/* | sort -u`; for log in $logs;do echo `ls -la $log`;done;


# finds service elaped times for the current day. This is helpful for pinpointing external service issues.
day=`date | awk '{print $3}'`;list=`ls -lahrt /logs/tipsi|grep $day|grep "tipsid.*.*.log"|awk '{print $9}'`;for file in $list; do echo `grep "Service Elapsed" /logs/tipsi/$file|awk '{print $7,$8}'|sort -u`;done;


# looks for Out of Memory errors in the current day's expo customs weblog.
day=`date | awk '{print $3}'`;list=`ls -lahrt /logs/jvm/customs/web/*.out|grep $day|awk '{print $9}'`;for file in $list; do echo `grep "Memory" $file|grep -v "SEVERE"|grep -v "Polling"`;done;


# run pingstats from one branch to another and log the results in a text file. 
me=`whoami`;read -p "Which branch are we testing? " bbb; ping -s $bbb.$bbb.ei 1500 100 >> /export/home/$me/pingstats_${HOSTNAME}_to_$bbb.txt


# The below commands are meant for use by Customs support.
#This command must be run from your chq login to unix. finds all instances of a file's updates inside the dihpublish logs and puts it in a file. then emails the contents to the import helpdesk.
read -p "Which file number? " file;me=`whoami`;gzgrep -h "$file" /logs/mpe/import/dihpublish/${HOSTNAME^^}/* >> /export/home/$me/$file.txt;mailx -s "$file" import.helpdesk@expeditors.com < /export/home/$me/$file.txt


# pull the entry response for a given entry number on the current day.
me=`whoami`;read -p "What is the Entry Number?: " entry; grep "$entry" /logs/jvm/customs/web/customs/UsWebServices.log | grep "Response" >> /export/home/$me/$entry.txt


# pull the entry response from a given historical day.
me=`whoami`;read -p "What is the Entry Number?: " entry; read -p "What date? YYYY-MM-DD: " date; gzgrep "$entry" /logs/jvm/customs/web/customs/UsWebServices/UsWebServices.$date.*.log.gz | grep "Response" >> /export/home/$me/$entry.txt


# We as software developers all know that all software has actually already been written. And all of it, of course, has all been posted to Stack Overflow. So, it isn't inconceivable that you're going to have to deal with code that you're pasting in from someone else's project.
read -p "what date are we looking for? enter in 'Mmm dd' i.e. December 13th is Dec 13" day;read -p "which files are we looking for? seperate with '|' :" search;files=`ls -la|grep $day|awk '{print $9}'`;for file in files; do echo `egrep "$search" /prod/app/ip/data/extract/$file`;done;