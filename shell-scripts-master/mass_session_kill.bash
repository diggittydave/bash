#!/bin/bash
#Commands written by chq-davidwe
#
#these scripts should be run from your chq login only. 
#
#If you have questions, or something isn't working right, contact chq-davidwe.
#
# one liner to kill sessions in mpe environment. 
export sessions=$(sj |  egrep "EXEC" | egrep -v "$user|EIFA|CORP|SCHED|SESSIONS|#J|REVIEW" | tr -s ' ' | cut -d ' ' -f 1 | cut -d 'S' -f 2); for session in $sessions; do echo "ABORTSESSION $session | n"; done ; export check=$( sj | egrep "EXEC|#J" | egrep -v "#S|EIFA|CORP|SCHED|SESSIONS|WAIT"); while [ -n "${check}" ]; do check=$(  sj | egrep "EXEC|#J" | egrep -v "#S|EIFA|CORP|SCHED|SESSIONS|WAIT" ) &&  sj | egrep "EXEC|#J" | egrep -v "#S|EIFA|CORP|SCHED|SESSIONS|WAIT" && sleep 10 && clear; done; echo All jobs are down
