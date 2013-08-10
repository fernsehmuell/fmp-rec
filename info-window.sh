while :
do
	clear
	freespace=`df -h | grep rootfs | awk '{print $4}' `
	echo "* INFO Window (10s refresh)*"
	echo "****************************"
	echo "free Space: "$freespace
	echo "date: "$(date)
	echo ""
	sleep 10s
done


