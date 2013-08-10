#!/bin/bash
#

while :
do
clear
echo "          FMP Recorder 0.0.3"
echo "    ----------------------------- "
echo "   |   (7)   |   (8)   |   (9)   |"
echo "   | Record! |  Stop!  |Set Date!|"
echo "    ----------------------------- "
echo "   |   (4)   |   (5)   |   (6)   | "
echo "   |Play last|         |move data|"
echo "    ----------------------------- "
echo "   |   (1)   |   (2)   |   (3)   |"
echo "   |         |         |Shutdown!|"
echo "    ----------------------------- "
read -n 1 -s chosen
case $chosen in
7) 	echo -n "starting recording";
	tmux send-keys -t FMP:REC.1 /home/pi/fmp-rec/start-recorder.sh C-m ;
	echo recording.... ;
	;;

8) 	echo -n "stopping in 3 seconds...";
	sleep 3;
	tmux send-keys -t FMP:REC.1 C-c ;
	;;

4)	echo -n "starting playback of last clip";
	tmux send-keys -t FMP:REC.1 "play /home/pi/last.wv" C-m;
	;;

6)	clear;
	echo "mounting /mnt/freigabe";
	mount /mnt/freigabe
	echo "moving all audio files..."
	mv -v /home/pi/*.wv /mnt/freigabe;
	echo "unmounting /mnt/freigabe";
	umount /mnt/freigabe
	echo "press enter to continue";
	read
	;;

3)	shutdown -h +2;
	tmux send-keys -t FMP:REC.1 C-c ;
	;;

9)	clear;
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
