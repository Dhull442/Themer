#!/bin/bash
timeout=$1
location=$2
# read -p "Enter the change timing(S): " timeout
# read -p "Enter the location of folder:" location
num=$(ls $location | grep "png\|jpg\|jpeg"| wc -l)
a=$(ls $location | grep "png\|jpg\|jpeg" )
if [[ $num -lt 1 ]]; then 
	echo "No image file present"
	exit 1;
fi
limitime=$(( timeout - 4 ))
starttime=$(date +%s)
while true 
do
if [[ $(( $(date +%s) - starttime )) -ge $timeout ]]; then
	# Change Wallpaper
	randomfilenum=$(( ( RANDOM%$num ) + 1 ))
	filename=$(echo $a | cut -f$randomfilenum -d ' ')
	filelocation="$location"/"$filename"
	gsettings set org.gnome.desktop.background picture-uri file://"$filelocation"
	notify-send -i "$filelocation" "Wallpaper Changed" ; sleep 3; killall notify-osd;
	starttime=$(date +%s)
	sleep $limitime;
fi
done

