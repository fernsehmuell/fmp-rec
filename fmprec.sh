#!/bin/bash
#

while :
do
clear
echo " FMP Recorder 0.0.2 "
echo "********************"
echo "* (R)ecord         *"
echo "* (S)top           *"
echo "* (P)lay last      *"
echo "* (Q)uit           *"
echo "* (I)nfo           *"
echo "* Set (D)ate+Time  *"
echo "* (H)alt/Shutdown  *"
echo "********************"
echo "Press button:"
read -n 1 -s chosen
case $chosen in
r) 	echo "RECORD!";
	tmux send-keys -t FMP:REC.1 /home/pi/fmp-rec/start-recorder.sh C-m ;
	echo recording.... ;
	;;

s) 	echo "Stop! wait for 3 seconds and then stop recording or playback";
	sleep 3;
	tmux send-keys -t FMP:REC.1 C-c ;
	;;

p)	echo "play";
	tmux send-keys -t FMP:REC.1 "play /home/pi/last.wv" C-m;
	;;

q) 	echo "CU"; 
	tmux send-keys -t FMP:REC.1 C-c ;
	tmux send-keys -t FMP:REC.1 exit C-m ;
	exit 0;
	;;

h)	shutdown -h +2;
	tmux send-keys -t FMP:REC.1 C-c ;
	;;

d)	clear;
	echo "please enter Date";
	echo "in EXACTLY this format:";
	echo "MMDDhhmmYYYY";
	echo "example: 052612592013";
	read userdate;
	date $userdate;
	;;

*) 	echo "ooooops again please (r,s,q)" ;
	echo "press enter to continue" ;
	;;
esac
done
