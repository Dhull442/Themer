#!/bin/bash

## Checks if already running
PROGRAM="main.sh"
pid=$(pgrep -f $PROGRAM)
n_pid=$(pgrep -f $PROGRAM | wc -l )
echo $n_pid
echo $pid
echo $(pgrep -f $PROGRAM )
if [[ $n_pid -gt 1 ]]; then
	echo "Themer already running on PID $(echo $pid| cut -f1 -d' ')"
	#exit 1;
fi

## Program Starting Point
if (( $# != 2 )); then
   echo "Run as themer <timeout in seconds> <folder containing files>"
	exit 1;
fi
# Input Method 1
timeout=$1
rel_location=$2

# Input Method 2
## Uncomment these for second way of input of arguments
# read -p "Enter the change timing(S): " timeout
# read -p "Enter the location of folder:" rel_location

if ! [[ "$timeout" =~ ^[0-9]+$  ]]; 
then
    echo "Timeout Must be an integer"
    exit 1;
fi
if [[ $timeout -le 5 ]]; then   # exit if timeout is very less
	echo "Timeout must be greater than 5s"
	exit 1;
fi
location=$(readlink -f $rel_location)
num=$(ls $location | grep "png\|jpg\|jpeg\|PNG\|JPG\|JPEG"| wc -l)

if [[ $num -lt 1 ]]; then 
	echo "No image file present in $location"
	exit 1;
fi

limitime=$(( timeout - 4 ))

lastrandomfilenum=1
starttime=$(date +%s)
notify-send "themer started on PID $pid"
while true 
do
if [[ $(( $(date +%s) - starttime )) -ge $timeout ]]; then
	# Change Wallpaper
	num=$(ls $location | grep "png\|jpg\|jpeg\|PNG\|JPG\|JPEG"| wc -l)
	randomfilenum=$(( ( RANDOM%$num ) + 1 ))
	while [[ $randomfilenum == $lastrandomfilenum ]];
	do
		randomfilenum=$(( ( RANDOM%$num ) + 1 )); 
	done	
	lastrandomfilenum=$randomfilenum
	filename=$(ls $location | grep "png\|jpg\|jpeg\|PNG\|JPG\|JPEG" | sed -n ${randomfilenum}p)
	filelocation="$location"/"$filename"
	gsettings set org.gnome.desktop.background picture-uri file://"$filelocation"
	notify-send -i "$filelocation" "Wallpaper Changed" ; sleep 3; killall notify-osd;
	starttime=$(date +%s)
	echo "Wallpaper changed to $filename";
	sleep $limitime;
fi
done

