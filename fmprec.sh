#!/bin/bash
#
echo "no markers set" > marker.txt

while :
do

clear
echo "    FMP Recorder 0.0.4 - menu 1/2"
echo "    ----------------------------- "
echo "   |   (7)   |   (8)   |   (9)   |"
echo "   | Record! |  Stop!  |play last|"
echo "    ----------------------------- "
echo "   |   (4)   |   (5)   |   (6)   | "
echo "   |         |         |         |"
echo "    ----------------------------- "
echo "   |   (1)   |   (2)   |   (3)   |"
echo "   | Marker! |         |  Menu2  |"
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

9)	echo -n "starting playback of last clip";
	lastfilename=$(cat last.txt).wv
	tmux send-keys -t FMP:REC.1 "play /home/pi/$lastfilename" C-m;
	;;

1)	marktime=$(date +%s);
	markTCseconds=$(($marktime-$start));
	markTChhmmss=$(date -u -d @$markTCseconds +"%T");
	markerfile=$(cat last.txt);
	if (($(echo "$marker==0" | bc)));
		then echo "#,Name,Start" > $markerfile.csv;
		echo "no markers set" > marker.txt;
	fi;
	marker=$((marker+1));
	echo "M"$marker",,"$markTChhmmss >> $markerfile.csv;
	echo -n "set Marker at TC: "$markTChhmmss;
	echo "M"$marker": "$markTChhmmss > marker.txt
	;;

3)	while :
	do
	clear;
	echo "    FMP Recorder 0.0.4 - menu 2/2"
	echo "    ----------------------------- "
	echo "   |   (7)   |   (8)   |   (9)   |"
	echo "   |set date!|move data| reboot! |"
	echo "    ----------------------------- "
	echo "   |   (4)   |   (5)   |   (6)   | "
	echo "   |         |         |shutdown!|"
	echo "    ----------------------------- "
	echo "   |   (1)   |   (2)   |   (3)   |"
	echo "   |         |         |  Menu1  |"
	echo "    ----------------------------- "
	read -n 1 -s chosen2
	case $chosen2 in
		3) echo "3";
		break;
		;;
		7) clear;
		echo "please enter Date";
		echo "in EXACTLY this format:";
		echo "MMDDhhmmYYYY";
		echo "example: 052612592013";
		read userdate;
		date $userdate;
		;;

		8) clear;
		echo "mounting /mnt/freigabe";
		mount /mnt/freigabe > /dev/nul
		echo "moving all marker files..."
		mv /home/pi/*.csv /mnt/freigabe;
		echo "moving all audio files..."
		mv /home/pi/*.wv /mnt/freigabe;
		echo "unmounting /mnt/freigabe";
		umount /mnt/freigabe > /dev/nul
		echo "press enter to continue";
		read
		;;

		9) reboot;
		;;

		6) shutdown -h now;
		;;

		*)
		;;
	esac;
	done
	;;


*)	;;
esac
done
