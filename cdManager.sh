#!/bin/bash

#update
#insert/remove/alter
#find
#play

#task: 添加Tracks时，自动添加Records 

#*********************************************************

insertRecordLine(){
	catalogNum=$(grep -c -h ^CD Records.file)
	catalogNum=$(($catalogNum+1))
	echo "CD${catalogNum} $*" >> Records.file
	catalogNum=$(($catalogNum+1))
	cat Records.file | sort > temp.file
	mv temp.file Records.file
	return
}
insertTrackLine(){
	cdName=$1
	trackName=$2
	trackNum=0
	catalogNum=0
	echo "	test $cdName"
	recordLine=$(grep -h $cdName Records.file)
	if [ $recordLine="" ] #if no found, add the CD to Records.file
	then
		insertRecordLine $cdName 
	fi
	recordLine=$(grep -h $cdName Records.file)
	echo "	test $recordLine"
	set $recordLine
	catalogNum=$1

	trackNum=$(grep -h -c ^$catalogNum Tracks.file)
	echo "	test $trackNum"
	trackNum=$(($trackNum+1))
	echo "$catalogNum $trackNum $trackName" >> Tracks.file
	cat Tracks.file | sort > temp.file
	mv temp.file Tracks.file
	
	return
}
insertRecords(){
	echo "Title Type Composer"
	read lineRecord	
	
	insertRecordLine $lineRecord #insert line to Record.file
	return 
}

insertTracks(){
	echo "CD-Name Track-Name"
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
	echo -n ":"
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
 	if grep -h [[:blank:]]$trackName$ Tracks.file 
	then
		:
	else
		echo "NO FOUND"
	fi		
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
	echo "(ctl+c to stop)"
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
	echo -n ":"
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













































