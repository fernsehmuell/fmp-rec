clear
while :
do
	tput cup 0 0
	freespace=`df -h | grep rootfs | awk '{print $4}' `
	echo " INFO Window (10s refresh)"
	echo "****************************"
	echo "free Space: "$freespace
	echo "date: "$(date)

	sleep 10s
done


