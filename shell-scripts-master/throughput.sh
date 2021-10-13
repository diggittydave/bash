#!/bin/bash
# This is used to track throughput on a per/minute basis of the LDRBRCH logs.
# Output times are logged to throughput_stats.txt
#Options:
# 	-n : integer, used to set the number of loops the script will run.
#   -t : integer, the frequency of each loop in seconds, i.e. 60 = the loop will run once every 60 seconds.
#   -j : string, sets the joblong name to use for the calculations.
#   -i : clears screen shows other options, defaults, uses and examples.


# load mpe environment. In the future can be used to also check pend counts and do further calculations.
. $HOME/.profile
. /prod/mpe/.newlab
. /prod/mpe/systemStartup

# Treat unset variables as an error when substituting.
set -u

# Options menu loop
while [ $# -gt 0 ] ; do 
    case "$1" in 
		-n) runtime="$2"
			shift
			;;
		-t) freq="$2"
			shift
			;;
		-j) job="$2"
			echo "Looking in job $job"
			shift
			;;
		-i) clear # print out the available options, their defaults and uses.
			ymd=`date '+%y%m%d'`
			echo " "
			echo "Script written to calculate throughput of expin loads in various job logs.\r\n"
			echo "Options available for throuhput.sh"
			echo "-n : Integer, used to set the number of loops the script will run. \r\n     Default = 10"
			echo "     Example:\r\nchq-davidwe:pdx ~/>throughtput.sh -n 60 \r\n        The script will run through the calculation loop 60 times.\r\n"
			echo "-t : Integer, the frequency of each loop in seconds, i.e. 60 = the loop will run once every 60 seconds. \r\n     Default = 60"
			echo "     Example:\r\nchq-davidwe:pdx ~/>throughtput.sh -t 5 \r\n        The script will run the calculations every 5 seconds. \r\n"
			echo "-j : String, sets the joblog name to use for the calculations. \r\n     Default = LDRBRCH"
			echo "     Example:\r\nchq-davidwe:pdx ~/>throughtput.sh -j HOTRCV2 \r\n        The script will use the log HOTRCV2.${HOSTNAME^^}.20$ymd for calculation.\r\n"
			echo "\r\nThe options can be used in conjuction to further adjust how the job functions."
			echo "Example:\r\nchq-davidwe:pdx ~/>throughput.sh -n 100 -t 10 -j EXEDIHUB \r\n The script will calculate throughput of the EXEDIHUB.${HOSTNAME^^}.20$ymd log every 10 seconds a total of 100 times."
			echo "Output is logged to /tmp/throughput_for_EXEDIHUB.$ymd.txt"
			exit
			;;
		*) echo "Option $1 not recognized"
			break
			;;
	esac
	shift
done

# Set default values to use if an option is not set.
runtime2=10
freq2=60
job2="LDRBRCH"

#initiate counter
x=0

#get date for log file
ymd=`date '+%Y%m%d'`

# evaluate options versus defaults.
runtime=${runtime:-$runtime2}
freq=${freq:-$freq2}
job="${job:-$job2}"

# check for and create directory upon need
dir1="/logs/mpe/export/throughput/"
dir2="$dir1$job"
if [ -d "$dir1" ];
then
	if [ -d "$dir2" ]
	then
		echo "saving to $dir2"
	else
		echo "creating $dir2"
		mkdir $dir2
		chmod 777 $dir2
		chown MGR:STAFF $dir2
		echo "saving to $dir2"
	fi
else
	echo "creating $dir1"
	mkdir $dir1
	chmod 777 $dir1
	chown MGR:STAFF $dir1
	echo "creating $dir2"
	mkdir $dir2
	chmod 777 $dir2
	chown MGR:STAFF $dir2
	echo "saving to $dir2"
fi

#create output file
file="$dir2/$job.$ymd.csv"
if [ -f  $file ];
then 
	echo "file exists"
else
	echo "setting up file"
	touch $file
	echo "TIMESTAMP,TOTAL EXPINS,TOTAL RECORDS" >> $file
fi

# echo out variables being used.
echo "Date: $ymd"
echo "Frequence of check: $freq"
echo "Joblog being monitored: $job"
echo "Number of times running: $runtime"
echo "Dumping data to $file"

# Set record to use for calculating throughput.
if [ $job = "EXEDIHUB" ];
then
	searchline="H1"
else
	searchline="T1"
fi
echo "Record being used to calculate throughput: $searchline"

# work loop
while [ $x -le $runtime ];
do
		ymd=`date '+%Y%m%d'`
		file="/tmp/throughput_for_$job.$ymd.csv"
		if [ -f  $file ];
		then 
			echo "file exists"
		else
			echo "setting up file"
			touch $file
			echo "TIMESTAMP,TOTAL EXPINS,TOTAL RECORDS" >> $file
		fi
		# get the current number of expins processed.
		time1=`grep ^$searchline /logs/mpe/export/EDIJOBS/${HOSTNAME^^}/$job.${HOSTNAME^^}.$ymd|wc -l`
		# get the total number of records in the file
		total1=`wc -l < /logs/mpe/export/EDIJOBS/${HOSTNAME^^}/$job.${HOSTNAME^^}.$ymd`
		# wait here
		sleep $freq
		# get the new number of expins processed.
		time2=`grep ^$searchline /logs/mpe/export/EDIJOBS/${HOSTNAME^^}/$job.${HOSTNAME^^}.$ymd|wc -l`
		# get the new number of records processed.
		total2=`wc -l < /logs/mpe/export/EDIJOBS/${HOSTNAME^^}/$job.${HOSTNAME^^}.$ymd`
		# calculate throughput of expin loads.
		time3=$((time2-time1))
		# calculate throughput of total records processed.
		total3=$((total2-total1))
		timestamp=`date '+%Y%m%d%H%M%S'`
		echo "$timestamp,$time3,$total3" >> $file
		# count up
		x=$(( $x + 1 ))
done


