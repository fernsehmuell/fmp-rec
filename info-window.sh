clear
while :
do
tput cup 0 0
freespace=`df -h | grep rootfs | awk '{print $4}' `
echo "FMP info window"
echo "--------------------------------"
echo "free Space: "$freespace
echo "date: "$(date +%d.%m.%Y)"  "$(date +%T)
echo "last marker: "$(cat marker.txt)
echo "--------------------------------"
echo "help: [move data] moves all"
echo "wv-files to /mnt/freigabe"

sleep 1s
done


