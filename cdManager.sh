#!/bin/bash

#update
#insert/remove/alter
#find
#play

#*********************************************************

insertRecordLine(){
	echo $* >> Records.file
	cat Records.file | sort > temp.file
	mv temp.file Records.file
	return
}
insertTrackLine(){
	echo $* >> Tracks.file
	cat Tracks.file | sort > temp.file
	mv temp.file Records.file
	return
}
insertRecords(){
	echo "catalog title type composer"
	read lineRecord
	
	#judge the input is vali
	set $lineRecord
	catalogCD=$1
	titleCD=$2
	typeCD=$3
	composerCD=$4
	
	insertRecordLine $lineRecord #insert line to Record.file
	return 
}

insertTracks(){
	echo "catalog number track-name"
	read lineTrack

	insertTrackLine $lineTrack	#insert line to Tracks.file
	return	
}
#****************************************************
removeRecords(){
	echo -n "Remove Catalog-Number: "
	read catalogNum
	grep -h -v "^${catalogNum}" Records.file > temp.file #remove the line with the head of xxx
	mv temp.file Records.file 
	grep -h -v "^${recordName}" Tracks.file > temp.file
	mv temp.file Tracks.file

	return
}

removeTracks(){
	echo -n "Remove Track: " 
	read trackName
	grep -h -v [[:space:]]$trackName[[:space:]] Tracks.file > temp.file #need to be optimized
	mv temp.file Tracks.file
	return
}
#******************************************************
# test
alterRecords(){
	echo -n "Choose Catalog-Number: "
	read catalogNum
	grep -h "^$catalogNum" Records.file
	grep -v "^$catalogNum" Records.file > temp.file
	mv temp.file Records.file
	
	echo -n "new Records infomation: "
	read newCDInfo
	echo $newCDInfo >> Records.file
	
	cat Records.file | sort | uniq > temp.file
	mv temp.file Records.file
	
	return
}
# test
alterTracks(){
	echo -n "lterTracks"
	return
}
#*********************************************************
updateCD(){
while true
do
cat <<!UPDATE!
1.insert records
2.insert tracks
3.remove records
4.remove tracks
5.alter records
6.alter tracks
!UPDATE!
	read updateChoice

	case "$updateChoice" in
	1 )	insertRecords
		echo "insert Records success"
		break;;
	2 ) insertTracks
		echo "insert Tracks success"
		break;;
	3 ) removeRecords
		echo "remove Records success"
		break;;
	4 ) removeTracks
		echo "remove Tracks success"
		break;;
	5 ) alterRecord
		break;;
	6 ) alterTracks
		break;;
	* ) echo "Enter the valid choice";;
	esac
done

return

}
#***********************************************************
findCD() {
	echo -n "Track-Name: "
	read trackName
	grep -h $trackName Tracks.file
	
	return
}
#************************************************************
# stop playing tracks
stop() {
	playEn=false
	echo "stop $*"
	return
}

# play tracks
playCD() {
	playEn=true
	echo -n "Track-Name: "
	read trackName
	echo "ctl+c to stop"
	grep -h $trackName Tracks.file
	trap 'stop $trackName ' INT
	
	while $playEn
	do
		echo "Play $trackName"
		sleep 1
	done

	return
}

# main function

# variable 
playEn=true


echo "Welcome to CDManager helper! Please choose which help you want to get."
# main loop
while true; do

cat <<!MENU!
1.update
2.find
3.play
4.exit
!MENU!

	read menuChoice

	case "$menuChoice" in
		1 ) updateCD;;
		2 ) findCD;;
		3 ) playCD;;
		4 ) break;;
		* ) echo "wrong input";;

	esac
done
exit 0













































