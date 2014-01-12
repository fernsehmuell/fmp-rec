#!/bin/bash
#
setterm -powersafe off -blank 0
zoomed=0;
recording=0;
marker=0;
zoom(){
   tmux new-window -d -n tmux-zoom
   tmux swap-pane -s tmux-zoom -t FMP:REC.0
   tmux select-window -t tmux-zoom
   /home/pi/fmp-rec/font2.sh
}

unzoom(){
   tmux swap-pane -s tmux-zoom -t FMP:REC.0
   tmux select-window -t FMP:REC
   tmux kill-window -t tmux-zoom
   /home/pi/fmp-rec/font0.sh
}

echo "no markers set" > marker.txt
zoom; zoomed=1;

while :
do
clear
echo "    FMP Recorder 0.0.5 - menu 1/2"
echo "   ┌─────────┬─────────┬─────────┐ "
echo "   │   (7)   │   (8)   │   (9)   │"
if (($(echo "$recording==1" | bc))); then echo -e  '   │ \E[37;41m'"\033[1mRecord!\033[0m │  Stop!  │play last│" ; temp=1; fi; 
if (($(echo "$recording==0" | bc))); then echo "   │ Record! │  Stop!  │play last│" ; temp=1; fi;
echo "   ├─────────┼─────────┼─────────┤"
echo "   │   (4)   │   (5)   │   (6)   │ "
echo "   │Marker-- │  zoom!  │         │"
echo "   ├─────────┼─────────┼─────────┤"
echo -e '   │   \E[37;41m'"\033[1m(1)\033[0m" '  │   ''\E[37;42m'"\033[1m(2)\033[0m"'   │   (3)   │'
echo "   │ Marker! │ Marker! │  Menu2  │"
echo "   └─────────┴─────────┴─────────┘"
read -n 1 -s chosen
case $chosen in
4)	echo "letzen Marker löschen... (Baustelle)"
	if (($(echo "$marker>0" | bc))); then 
		marker=$((marker-1));
		head -n -1 $markerfile.csv > temp.txt
		cp temp.txt $markerfile.csv
		head -n -1 marker.txt > temp.txt
		cp temp.txt marker.txt
	fi;
	;;
7) 	unzoom; zoomed=0;
	recording=1;
	echo -n "starting recording";
	start=$(date +%s);
	marker=0;
	tmux send-keys -t FMP:REC.1 /home/pi/fmp-rec/start-recorder.sh C-m ;
	echo recording.... ;
	;;

8) 	echo -n "stopping in 2 seconds...";
	sleep 2;
	recording=0;
	tmux send-keys -t FMP:REC.1 C-c ;
	zoom; zoomed=1;
	;;
9) 	unzoom; zoomed=0;
	echo -n "starting playback of last clip";
	lastfilename=$(cat last.txt).wv
	tmux send-keys -t FMP:REC.1 "play /home/pi/$lastfilename" C-m;
	;;

5)	if (($(echo "$zoomed==0" | bc))); then zoom  ; temp=1; fi;
	if (($(echo "$zoomed==1" | bc))); then unzoom; temp=0; fi;
	zoomed=$temp;
	;;

1)	if (($(echo "$recording==1" | bc))); then
		marktime=$(date +%s);
		markTCseconds=$(($marktime-$start));
		markTChhmmss=$(date -u -d @$markTCseconds +"%T");
		markerfile=$(cat last.txt);
		if (($(echo "$marker==0" | bc)));
			then echo "#,Name,Start,End,Length,Color" > $markerfile.csv;
			echo "no markers set" > marker.txt;
		fi;
		marker=$((marker+1));
		echo "M"$marker",,"$markTChhmmss",,,"0000FF >> $markerfile.csv;
		echo -n "set Marker at TC: "$markTChhmmss;
		echo "M"$marker": "$markTChhmmss >> marker.txt;
	fi;
	;;

2)	if (($(echo "$recording==1" | bc))); then
		marktime=$(date +%s);
		markTCseconds=$(($marktime-$start));
		markTChhmmss=$(date -u -d @$markTCseconds +"%T");
		markerfile=$(cat last.txt);
		if (($(echo "$marker==0" | bc)));
			then echo "#,Name,Start,End,Length,Color" > $markerfile.csv;
			echo "no markers set" > marker.txt;
		fi;
		marker=$((marker+1));
		echo "M"$marker",,"$markTChhmmss",,,"00FF00 >> $markerfile.csv;
		echo -n "set Marker at TC: "$markTChhmmss;
		echo "M"$marker": "$markTChhmmss >> marker.txt;
	fi;
	;;

3)	while :
	do
	clear;
	echo "    FMP Recorder 0.0.5 - menu 2/2"
	echo "   ┌─────────┬─────────┬─────────┐"
	echo "   │   (7)   │   (8)   │   (9)   │"
	echo "   │set date!│move data│ reboot! │"
	echo "   ├─────────┼─────────┼─────────┤"
	echo "   │   (4)   │   (5)   │   (6)   │"
	echo "   │         │         │shutdown!│"
	echo "   ├─────────┼─────────┼─────────┤"
	echo "   │   (1)   │   (2)   │   (3)   │"
	echo "   │         │         │  Menu1  │"
	echo "   └─────────┴─────────┴─────────┘"

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
