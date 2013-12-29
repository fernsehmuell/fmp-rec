clear
while :
do
  clear
  for i in {1..20}
  do
    tput cup 0 0
    freespace=`df -h | grep rootfs | awk '{print $4}' `
    echo "FMP info window"
    echo "--------------------------------"
    echo "free Space: "$freespace"  "
    echo "date: "$(date +%d.%m.%Y)"  "$(date +%T)
    echo "last marker: "$(tail -n 1 marker.txt)"  "
    echo "--------------------------------"
    echo "help: [move data] moves all"
    echo "wv-files to /mnt/freigabe"
    echo ""
    sleep 1s
  done
done


