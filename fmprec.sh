#!/bin/bash
#
echo 0 > marker.txt

while :
do
clear
echo "          FMP Recorder 0.0.4"
echo "    ----------------------------- "
echo "   |   (7)   |   (8)   |   (9)   |"
echo "   | Record! |  Stop!  |Set Date!|"
echo "    ----------------------------- "
echo "   |   (4)   |   (5)   |   (6)   | "
echo "   |Play last|         |move data|"
echo "    ----------------------------- "
echo "   |   (1)   |   (2)   |   (3)   |"
echo "   | Marker! |         |Shutdown!|"
echo "    ----------------------------- "
read -n 1 -s chosen
case $chosen in
7) 	echo -n "starting recording";
	start=$(date +%s);
	marker=0;
	tmux send-keys -t FMP:REC.1 /home/pi/fmp-rec/start-recorder.sh C-m ;
	echo recording.... ;
	;;

8) 	echo -n "stopping in 2 seconds...";
	sleep 2;
	tmux send-keys -t FMP:REC.1 C-c ;
	;;

4)	echo -n "starting playback of last clip";
	lastfilename=$(cat last.txt).wv
	tmux send-keys -t FMP:REC.1 "play /home/pi/$lastfilename" C-m;
	;;

6)	clear;
	echo "mounting /mnt/freigabe";
	mount /mnt/freigabe
	echo "moving all marker files..."
	mv -v /home/pi/*.csv /mnt/freigabe;
	echo "moving all audio files..."
	mv -v /home/pi/*.wv /mnt/freigabe;
	echo "unmounting /mnt/freigabe";
	umount /mnt/freigabe
	echo "press enter to continue";
	read
	;;

1)	echo "set Marker at TC: ";
	marktime=$(date +%s);
	markTCseconds=$(($marktime-$start));
	markTChhmmss=$(date -u -d @$markTCseconds +"%T");
	markerfile=$(cat last.txt);
	if (($(echo "$marker==0" | bc)));
		then echo "#,Name,Start" > $markerfile.csv;
	fi;
	marker=$((marker+1));
	echo "M"$marker",,"$markTChhmmss >> $markerfile.csv;
	echo "M"$marker": "$markTChhmmss > marker.txt
	;;

3)	shutdown -h now;
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
